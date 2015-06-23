class CctoolsRequirement < Requirement
  fatal true
  default_formula 'cctools'

  satisfy do
    MacOS::Xcode.installed? || MacOS::CLT.installed? || Formula['cctools'].installed?
  end
end
