class CctoolsRequirement < Requirement
  fatal true
  default_formula 'cctools'

  def initialize(tags)
    super
  end

  satisfy do
    satisfied = false

    if MacOS::XCode.installed? || MacOS::CLT.installed?
      satisfied = true
    elsif which('install_name_tool') && which('otool')
      satisfied = true
    else
      satisfied = false
    end

    satisfied
  end

  def message
    'cctools are required (via XCode, CLT, or Homebrew).'
  end
end
