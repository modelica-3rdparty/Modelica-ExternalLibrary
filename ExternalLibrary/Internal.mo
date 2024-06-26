within ExternalLibrary;
package Internal
  extends Modelica.Icons.InternalPackage;

  class ModelicaUtilityFunctions
    extends ExternalObject;

    function constructor
      "Function that call the external constructor"
      output ModelicaUtilityFunctions functions;

    external"C" functions =
        ModelicaUtilityFunctions_getModelicaUtilityFunctions() annotation (
          Include="#include \"ModelicaUtilityFunctions.c\"", IncludeDirectory="modelica://ExternalLibrary/Resources/Include");
    end constructor;

    function destructor
      input ModelicaUtilityFunctions functions;
    external"C" ModelicaUtilityFunctions_freeModelicaUtilityFunctions(functions)
        annotation (Include="#include \"ModelicaUtilityFunctions.c\"",
          IncludeDirectory="modelica://ExternalLibrary/Resources/Include");
    end destructor;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={Rectangle(
            lineColor={160,160,164},
            fillColor={160,160,164},
            fillPattern=FillPattern.Solid,
            extent={{-100.0,-100.0},{100.0,100.0}},
            radius=25.0)}));
  end ModelicaUtilityFunctions;

  class ExternalLibraryObject
    extends ExternalObject;

    function constructor
      input String filename;
      input String moduleName;
      input String className;
      input ExternalLibrary.Internal.ModelicaUtilityFunctions callbacks=ExternalLibrary.Internal.ModelicaUtilityFunctions();
      output ExternalLibraryObject externalObject;
    external"C" externalObject = createExternalObject(
          filename,
          moduleName,
          className,
          callbacks)
        annotation (Library="ExternalLibrary");
    end constructor;

    function destructor
      input ExternalLibraryObject externalObject;
    external"C" freeExternalObject(externalObject)
        annotation (Library="ExternalLibrary");
    end destructor;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}), graphics={Rectangle(
            lineColor={160,160,164},
            fillColor={160,160,164},
            fillPattern=FillPattern.Solid,
            extent={{-100.0,-100.0},{100.0,100.0}},
            radius=25.0)}));
  end ExternalLibraryObject;

  function externalLibraryFunction
    input String filename;
    input String moduleName;
    input String functionName;
    input Integer nu;
    input Real[nu] u;
    input Integer ny;
    output Real[ny] y;
    output String errorMessage;
  external"C" errorMessage = externalFunction(
      filename,
      moduleName,
      functionName,
      size(u, 1),
      u,
      size(y, 1),
      y) annotation (Library="ExternalLibrary");
  end externalLibraryFunction;
end Internal;
