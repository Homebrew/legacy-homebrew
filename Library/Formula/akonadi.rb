require 'formula'

class Akonadi < Formula
  homepage 'http://pim.kde.org/akonadi/'
  url 'http://download.akonadi-project.org/akonadi-1.5.0.tar.bz2'
  md5 '8b0d43b0e947b876a461d90f4b877f54'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'shared-mime-info'
  depends_on 'soprano'
  depends_on 'boost'
  depends_on 'qt'

  def install
    unless `/usr/bin/which mysql_config`.size > 0
      opoo "No MySQL client library detected"
      puts "This formula may fail to build, see caveats for more information."
    end

    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end

  def caveats; <<-EOS.undent
    DBSlayer depends on a MySQL client library.

    You can install this with Homebrew using:
      brew install mysql
        For MySQL server.

      brew install mysql-connector-c
        For MySQL client libraries only.

    We don't install these for you when you install this formula, as
    we don't know which datasource you intend to use.
    EOS
  end
end
