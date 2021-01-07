# MatLabTools
Repository storing some common material written in MatLab

## Repo Structure
There is no rigid structure in the repo. For the sake of good fractioning of the code, it would be great to have functions grouped by areas of applicability, resulting in not too many files in a single folder.

For the time being:

| folder name | description |
|-----|-----|
| `Educational` | scripts of general interest (e.g. showing bar of charge, beam quantities vs energy, etc...) |
| `MADX-optics` | scripts for plotting optics computed by MADX |
| `MADX-tracking` | scripts for plotting tracking data computed by MADX |
| `measurement_analysis` | scripts for performing some standard analysis or inspecting data |
| `optics` | tools for manipulating/computing optics quantities |

### Naming Conventions
No particularly strict rules, apart from:
* using [CamelCase](https://en.wikipedia.org/wiki/Camel_case "CamelCase") style (proposed);
* `Plot*` is a function that simply adds a plot to a `subplot` window, whereas a `Show*` function creates a brand new window with a collection of plots in a specific manner;

## References
* Official MathWorks docs about [function help](https://it.mathworks.com/help/matlab/matlab_prog/add-help-for-your-program.html "help functions"), i.e. the possibility to type in comments that are displayed by the help of the native MatLab editor;
* dirty way to implement [optional input parameters](https://it.mathworks.com/matlabcentral/answers/164496-how-to-create-an-optional-input-parameter-with-special-name "optional input parameters") to functions;
* Official MathWorks docs about [input parser](https://it.mathworks.com/help/matlab/ref/inputparser.html "input parser") (advanced);