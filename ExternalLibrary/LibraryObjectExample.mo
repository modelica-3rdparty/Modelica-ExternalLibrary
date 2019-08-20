within ExternalLibrary;
model LibraryObjectExample
  extends Modelica.Icons.Example;
  Modelica.Blocks.Sources.Sine sine(amplitude=1, freqHz=1)
    annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
  Modelica.Blocks.Sources.Sine sine1(amplitude=2, freqHz=1)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  LibraryObject libraryObject
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(sine.y, libraryObject.u[1]) annotation (Line(points={{-39,28},{-26,28},
          {-26,0},{-12,0}}, color={0,0,127}));
  connect(sine1.y, libraryObject.u[2]) annotation (Line(points={{-39,-30},{-26,
          -30},{-26,0},{-12,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})),
    experiment(__Dymola_fixedstepsize=0.001, __Dymola_Algorithm="Euler"),
    __Dymola_Commands(file="Resources/Scripts/plot.mos" "plot"));
end LibraryObjectExample;
