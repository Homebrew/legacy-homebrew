# -*- coding: utf-8 -*-

require 'formula'

class Mroonga < Formula
  homepage 'http://mroonga.github.com/'
  url 'https://github.com/downloads/mroonga/mroonga/mroonga-2.02.tar.gz'
  md5 '295754cd477838395ef3cb9936e12ede'

  if ARGV.include?("--use-homebrew-mysql")
    depends_on 'mysql'
  end
  depends_on 'groonga'

  def patches
    "https://github.com/mroonga/mroonga/commit/74bdbe71ec83e5495fdac675f284feb671a5cfea.diff"
  end

  def options
    [
      ["--use-homebrew-mysql", "Use MySQL installed by Homebrew"],
      ["--with-mysql-source=PATH", "MySQL source directory. This option is required without --use-homebrew-mysql"],
      ["--with-mysql-build=PATH", "MySQL build directory (default: guess from --with-mysql-source)"],
      ["--with-mysql-config=PATH", "mysql_config path (default: guess from --with-mysql-source)"],
      ["--with-debug[=full]", "Build with debug option"],
      ["--with-default-parser=PARSER", "Specify the default fulltext parser like --with-default-parser=TokenMecab (default: TokenBigram)"],
    ]
  end

  def install
    if ARGV.include?("--use-homebrew-mysql")
      build_mysql_formula do |mysql|
        Dir.chdir(buildpath.to_s) do
          install_mroonga(mysql.buildpath.to_s)
        end
      end
    else
      mysql_source_path = option_value("--with-mysql-source")
      if mysql_source_path.nil?
        raise "--use-homebrew-mysql or --with-mysql-source=PATH is required"
      end
      install_mroonga(mysql_source_path)
    end
  end

  def test
  end

  def caveats
    <<-EOS.undent
      To install mroonga plugin, run the following command:
         mysql -uroot -e '#{install_sql}'

      To confirm successfuly installed, run the following command
      and confirm that 'mroonga' is in the list:

         mysql> SHOW PLUGINS;
         +---------+--------+----------------+---------------+---------+
         | Name    | Status | Type           | Library       | License |
         +---------+--------+----------------+---------------+---------+
         | ...     | ...    | ...            | ...           | ...     |
         | mroonga | ACTIVE | STORAGE ENGINE | ha_mroonga.so | GPL     |
         +---------+--------+----------------+---------------+---------+
         XX rows in set (0.00 sec)
    EOS
  end

  private
  def build_mysql_formula
    mysql = Formula.factory("mysql")
    class << mysql
      def patches
        file_content = path.open do |file|
          file.read
        end
        data = path.open
        data.seek(file_content.index(/^__END__$/) + "__END__¥n".size)
        data
      end

      def system(command_line, *args)
        if command_line == "make install"
          throw :abort_install
        else
          super(command_line, *args)
        end
      end
    end

    mysql.brew do
      catch(:abort_install) do
        mysql.install
      end
      yield mysql
    end
  end

  def build_configure_args(mysql_source_path)
    configure_args = [
      "--prefix=#{prefix}",
      "--with-mysql-source=#{mysql_source_path}",
    ]

    mysql_config = option_value("--with-mysql-config")
    mysql_config ||= "#{mysql_source_path}/scripts/mysql_config"
    configure_args << "--with-mysql-config=#{mysql_config}"

    mysql_build_path = option_value("--with-mysql-build")
    if mysql_build_path
      configure_args << "--with-mysql-build=#{mysql_build_path}"
    end

    debug = option_value("--with-debug")
    if debug
      if debug == true
        configure_args << "--with-debug"
      else
        configure_args << "--with-debug=#{debug}"
      end
    end

    default_parser = option_value("--with-default-parser")
    if default_parser
      configure_args << "--with-default-parser=#{default_parser}"
    end

    configure_args
  end

  def install_mroonga(mysql_source_path)
    configure_args = build_configure_args(mysql_source_path)
    system("./configure", *configure_args)
    system("make")
    system("make install")
    system("mysql -uroot -e '#{install_sql}' || true")
  end

  def install_sql
    <<-EOS
INSTALL PLUGIN mroonga SONAME "ha_mroonga.so";
CREATE FUNCTION last_insert_grn_id RETURNS INTEGER SONAME "ha_mroonga.so";
EOS
  end

  def option_value(search_key)
    ARGV.options_only.each do |option|
      key, value = option.split(/=/, 2)
      return value || true if key == search_key
    end
    nil
  end
end
