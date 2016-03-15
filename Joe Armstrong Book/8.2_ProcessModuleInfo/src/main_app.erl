-module(main_app).

-export([start/0]).

start() ->
  ModulesFunctionsMap = getModulesFunctionsMap(),
  ModulesFunctionsCountMap = getModuleFunctionsNumber(ModulesFunctionsMap),
  io:format("Loaded modules(~p): ~n~p~n~n",[erlang:length(getModules()), getModules()]),
  io:format("Module functions number:~n~p~n~n",[ModulesFunctionsCountMap]),
  io:format("Module with the max number of functions:~n~p~n~n", [getMaxFunctionsModule(ModulesFunctionsCountMap)]),
  io:format("Unambiguous function names:~n~p", [getUnambiguousFunctionNames(ModulesFunctionsMap)]).

getLoadedModules() -> code:all_loaded().
getModules() -> lists:sort(maps:keys(getModulesFunctionsMap())).

%returns map of form #{ module_name => [{function name, arity]}
getModulesFunctionsMap() -> getModulesFunctionsMap(getLoadedModules(), #{}).
getModulesFunctionsMap([], ModuleMap) -> ModuleMap;
getModulesFunctionsMap([{ModuleName, _ModulePath}|Modules], ModuleMap) when is_map(ModuleMap) ->
  case maps:is_key(ModuleName, ModuleMap) of
    false -> getModulesFunctionsMap(Modules, ModuleMap#{ ModuleName => getMethodsByModuleName(ModuleName)})
  end.

getMethodsByModuleName(ModuleName) ->
  ModuleInfo = apply(ModuleName, module_info, []),
  ExportsFromModuleInfo = getExportsFromModuleInfo(ModuleInfo),
  getMethodsFromExports(ExportsFromModuleInfo).

getExportsFromModuleInfo(ModuleInfo) -> [_Module, Exports | _OtherStuff] = ModuleInfo, Exports.
getMethodsFromExports(Exports) -> {exports, MethodAndArityList} = Exports, MethodAndArityList.

%returns a map of form #{module_name => functions_number}
%arguments: [map of form obtained by getModulesFunctionsMap/0]
getModuleFunctionsNumber(ModuleMap) when is_map(ModuleMap) ->
  getModuleFunctionsNumber(maps:keys(ModuleMap), maps:values(ModuleMap), #{}).

getModuleFunctionsNumber([], [], Map) -> Map;
getModuleFunctionsNumber([Key|Keys], [Value|Values], Map) ->
  getModuleFunctionsNumber(Keys, Values, Map#{Key => erlang:length(Value)}).

%returns a tuple of form {module_with_max_number_of_functions, number_of_functions}
%arguments: [map of form obtained by getModuleFunctionsNumber/1]
getMaxFunctionsModule(FuncCountMap) -> getMaxFunctionsModule(maps:keys(FuncCountMap), maps:values(FuncCountMap)).
getMaxFunctionsModule([], []) -> "no values";
getMaxFunctionsModule([Module|Modules], [Value|Values]) ->
  getMaxFunctionsModuleHelper(Modules, Values, Module, Value).

getMaxFunctionsModuleHelper([], [], MaxModule, MaxValue) -> {MaxModule, MaxValue};
getMaxFunctionsModuleHelper([Module|Modules], [Value|Values], MaxModule, MaxValue) ->
  case Value > MaxValue of
    true -> getMaxFunctionsModuleHelper(Modules, Values, Module, Value);
    false -> getMaxFunctionsModuleHelper(Modules, Values, MaxModule, MaxValue)
  end.

%returns all unambiguous function names, that is, function names that are used in only one module
%arguments: [map of form obtained by getModulesFunctionsMap/0]
getUnambiguousFunctionNames(ModuleMap) when is_map(ModuleMap) ->
  Mapkeys = maps:keys(ModuleMap),
  iterateModules(ModuleMap, Mapkeys, []).

iterateModules(_ModuleMap, [], ResultList) -> lists:usort([ Func || {Func, _Arity} <- ResultList]);

iterateModules(ModuleMap, [Module|Modules], ResultList) ->
  Funcs = iterateFunctions(ModuleMap, Module, maps:get(Module, ModuleMap), []),
  iterateModules(ModuleMap, Modules, ResultList ++ Funcs).

iterateFunctions(_ModuleMap, _Module, [], ResultList) -> ResultList;
iterateFunctions(ModuleMap, Module, [Function|FunctionList], ResultList) ->
  case isUnambiguousFunction(ModuleMap, Module, Function) of
    true -> iterateFunctions(ModuleMap, Module, FunctionList, [Function|ResultList]);
    false -> iterateFunctions(ModuleMap, Module, FunctionList, ResultList)
  end.

isUnambiguousFunction(ModuleMap, Module, Function) ->
  case lists:member(Function, lists:flatten(maps:values(ModuleMap)) -- lists:flatten(maps:get(Module,ModuleMap))) of
    false -> true;
    true -> false
  end.