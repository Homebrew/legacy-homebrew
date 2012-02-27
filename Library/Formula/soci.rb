require 'formula'

class Soci < Formula
  homepage 'http://soci.sourceforge.net/'
  url 'http://download.sourceforge.net/project/soci/soci/soci-3.1.0/soci-3.1.0.zip'
  md5 '6ffac090b996bc34aedf4a29adf4595c'

  depends_on 'cmake' => :build
  depends_on 'boost' => :build if ARGV.include? '--boost'

  def options
  [
    ['--boost', 'Enable boost support.'],
    ['--mysql', 'Enable MySQL support.'],
    ['--oracle', 'Enable Oracle support.'],
    ['--odbc', 'Enable ODBC support.'],
    ['--pg', 'Enable PostgreSQL support.'],
  ]
  end

  def install
    args = std_cmake_parameters.split + [
      '-DWITH_SQLITE3:BOOL=ON',
    ]

    if ARGV.include? '--boost'
      args << "-DWITH_BOOST:BOOL=ON"
    else
      args << "-DWITH_BOOST:BOOL=OFF"
    end

    if ARGV.include? '--mysql'
      args << "-DWITH_MYSQL:BOOL=ON"
    else
      args << "-DWITH_MYSQL:BOOL=OFF"
    end

    if ARGV.include? '--oracle'
      args << "-DWITH_ORACLE:BOOL=ON"
    else
      args << "-DWITH_ORACLE:BOOL=OFF"
    end

    if ARGV.include? '--odbc'
      args << "-DWITH_ODBC:BOOL=ON"
    else
      args << "-DWITH_ODBC:BOOL=OFF"
    end

    if ARGV.include? '--pg'
      args << "-DWITH_POSTGRESQL:BOOL=ON"
    else
      args << "-DWITH_POSTGRESQL:BOOL=OFF"
    end

    args << ".."

    mkdir 'build' do
      system "cmake", *args
      system "make"
      system "make install"
    end
  end
end
