module Types
  include Dry.Types()

  Callable = Types.Interface(:call)
  PlayerFactionType = Symbol.enum(:rebel, :empire)
end

