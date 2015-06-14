class CctoolsRequirement < Requirement
  fatal true
  default_formula 'cctools'

  satisfy do
    MacOS::Xcode.installed? || MacOS::CLT.installed? || Dir.exists?('/usr/local/opt/cctools')
  end
end
