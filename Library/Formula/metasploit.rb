require 'formula'
require 'requirement'

# class Ruby192EqualGreater < Requirement
#   fatal true
#   # default_formula 'ruby'

#   satisfy {
#     ruby_ver_required = Version.new('1.9.2')

#     if which('rvm') && ENV.has_key?('MY_RUBY_HOME')
#       ruby_ver_installed = Version.new(`$MY_RUBY_HOME/bin/ruby -e "puts RUBY_VERSION"`) # RVM Default
#     else
#       ruby_ver_installed = Version.new(`ruby -e "puts RUBY_VERSION"`) # System Default
#     end

#     if ruby_ver_installed >= ruby_ver_required
#       true
#     else
#       puts "Error: Requires ruby >=#{ruby_ver}. You have #{ruby_ver_installed}"
#     end
#   }
# end

class Metasploit < Formula
  homepage 'http://www.metasploit.com/framework/'
  head 'https://github.com/rapid7/metasploit-framework.git'
  url 'https://github.com/rapid7/metasploit-framework.git', :using => :git, :tag => '4.8.0'

  # depends_on Ruby192EqualGreater
  # depends_on 'ruby' => '1.9.3'
  depends_on 'ruby'
  depends_on 'bundler' => :ruby

  def install
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/msf*"]

    cd "#{libexec}" do
      # if which('rvm') && ENV.has_key?('MY_RUBY_HOME')
      #   system "export PATH=$HOME/.rvm/bin:$PATH && bundle install"
      # else
      puts `ruby --version`
      puts `bundle --version`
      system "bundle install --without development test"
      # end
    end
  end
end
