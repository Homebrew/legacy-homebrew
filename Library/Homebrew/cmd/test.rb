module Homebrew extend self
  def test
    ARGV.formulae.each do |f|
      # Cannot test uninstalled formulae
      unless f.installed?
        ohai "#{f.name} not installed"
        next
      end

      # Cannot test formulae without a test method
      unless f.respond_to? :test
        onoe "#{f.name} defines no test"
        next
      end

      ohai "Testing #{f.name}"
      begin
        f.test
      rescue
        opoo "#{f.name}: failed"
      end
    end
  end
end
