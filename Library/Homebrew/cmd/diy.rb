module Homebrew extend self
  def diy
    path = Pathname.getwd

    version = if ARGV.include? '--set-version'
      ARGV.next
    elsif path.version.to_s.empty?
      raise "Couldn't determine version, try --set-version"
    else
      path.version
    end

    name = if ARGV.include? '--set-name'
      ARGV.next
    else
      path.basename.to_s =~ /(.*?)-?#{version}/
      if $1.to_s.empty?
        path.basename
      else
        $1
      end
    end

    prefix = HOMEBREW_CELLAR+name+version

    if File.file? 'CMakeLists.txt'
      puts "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    elsif File.file? 'Makefile.am'
      puts "--prefix=#{prefix}"
    else
      raise "Couldn't determine build system"
    end
  end
end
