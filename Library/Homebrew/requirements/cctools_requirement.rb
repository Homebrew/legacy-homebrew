# Represents a general requirement for utilities normally installed by Xcode,
# the CLT, or provided by the cctools formula. In particular, this requirement
# allows Homebrew to pull in the cctools formula and use its utilities to
# perform relocation operations on systems that do not have either Xcode or the
# CLT installed (but still want to install bottled formulae).
class CctoolsRequirement < Requirement
  fatal true
  default_formula "cctools"

  satisfy(:build_env => false) do
    MacOS::Xcode.installed? || MacOS::CLT.installed? || Formula["cctools"].installed?
  end
end
