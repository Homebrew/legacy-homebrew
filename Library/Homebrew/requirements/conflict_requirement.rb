require 'requirement'

# This requirement added by the `conflicts_with` DSL method.
class ConflictRequirement < Requirement
  attr_reader :formula

  # The user can chose to force installation even in the face of conflicts.
  fatal !ARGV.force?

  def initialize formula, name, opts={}
    @formula = formula
    @name = name
    @opts = opts
    super(formula)
  end

  def message
    message = "#{@name.downcase} cannot be installed alongside #{@formula}.\n"
    message << "This is because #{@opts[:because]}\n" if @opts[:because]
    message << <<-EOS.undent unless ARGV.force?
      Please `brew unlink #{@formula}` before continuing. Unlinking removes
      the formula's symlinks from #{HOMEBREW_PREFIX}. You can link the
      formula again after the install finishes. You can --force this install
      but the build may fail or cause obscure side-effects in the end-binary.
    EOS
    message
  end

  satisfy :build_env => false do
    keg = Formula.factory(@formula).prefix
    not keg.exist? && Keg.new(keg).linked?
  end
end
