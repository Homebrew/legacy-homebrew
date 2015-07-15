module FactoryBehavior

  # Install-like behavior where we search all taps following the priority.
  # If multiple formulae are found in the highest priority level, users will be asked to make a selection on the spot.
  INSTALL_LIKE = 0

  # Enforce the uniqueness of the formula.
  # If multiple formulae (with any priority) are found, throw TapFormulaAmbiguityError.
  ENFORCE_UNIQUE = 1

  # Choose any formula from highest priority level.
  # This should only be used when the command does not really care about what formula it is referring to.
  CHOOSE_ANY = 2

  # Try to look for the already installed formula.
  # If not found follow the behavior of ENFORCE_UNIQUE
  # TODO: not implemented!
  KEG_FIRST = 3

  # Return only core formula.
  CORE_ONLY = 4
end
