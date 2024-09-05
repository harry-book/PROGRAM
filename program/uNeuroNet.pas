unit uNeuroNet;

interface

uses Classes, SysUtils, uArrays;

type

 tNeuroNet = class
  protected
   input_nodes,
   hide_nodes,
   out_nodes      : int32;
   learn_grate    : float;
   wih, who,
   inputs,
   targets,
   hidden_inputs,
   hidden_outputs,
   final_inputs,
   final_outputs,
   output_errors,
   hidden_errors  : tFloatArray;
  public
   constructor Create(i_nodes,h_nodes,o_nodes : int32; l_grade : float);
   procedure   Init();
   procedure   Train(var a_inp,a_tar : tFloatArray);
  end;

implementation

  constructor tNeuroNet.Create(i_nodes,h_nodes,o_nodes : int32; l_grade : float);
  begin
   inherited Create;
   input_nodes := i_nodes;
   hide_nodes  := h_nodes;
   out_nodes   := o_nodes;
   learn_grate := l_grade; // 0.3
   wih         := tFloatArray.Create(hide_nodes, input_nodes);
   who         := tFloatArray.Create(out_nodes, hide_nodes);
  end;

  procedure tNeuroNet.Init();
  begin
   wih.random_norm_val(hide_nodes,0.5);
   who.random_norm_val(out_nodes,0.5);
   wih.printf();
   writeln;
   who.printf();
  end;

  procedure  tNeuroNet.Train(var a_inp,a_tar : tFloatArray);
  var
   A : tFloatArray;
  begin
   inputs         := a_inp.T();
   targets        := a_tar.T();

   hidden_inputs  := wih.dot_array(inputs);
   hidden_outputs := hidden_inputs.sigm();
   final_inputs   := who.dot_array(hidden_outputs);
   final_outputs  := final_inputs.sigm();

   output_errors  := targets.sub_array(final_outputs);
   A              := who.T();
   hidden_errors  := A.dot_array(output_errors);

  end;

end.
