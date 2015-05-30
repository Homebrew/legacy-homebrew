class CctoolsRequirement < Requirement
  fatal true
  default_formula 'cctools'

  satisfy do
    MacOS::XCode.installed? || MacOS::CLT.installed?
  end
end
