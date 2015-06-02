class CctoolsRequirement < Requirement
  fatal true
  default_formula 'cctools'

  satisfy(:build_env => false) do
    MacOS::Xcode.installed? || MacOS::CLT.installed? || Formula['cctools'].installed?
  end
end
