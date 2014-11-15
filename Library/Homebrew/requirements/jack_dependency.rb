require "requirement"

class JackDependency < Requirement
  fatal true
  default_formula "jack"
  satisfy { Formula["jack"].installed? || self.class.binary_jack_installed? }

  def self.binary_jack_installed?
    File.exist?("/usr/local/include/jack/jack.h") && File.exist?("/usr/local/bin/jackd")
  end

  env do
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_PREFIX/"Library/ENV/pkgconfig/jack"
  end

end

class ConflictsWithBinaryJack < Requirement
  fatal true
  satisfy { HOMEBREW_PREFIX.to_s != "/usr/local" || !JackDependency.binary_jack_installed? }

  def message
    <<-EOS.undent
      Jack is already installed from the binary distribution and
      conflicts with this formula.
    EOS
  end
end
