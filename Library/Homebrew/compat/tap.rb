require "tap"

class Tap
  def core_formula_repository?
    core_tap?
  end
end

CoreFormulaRepository = CoreTap
