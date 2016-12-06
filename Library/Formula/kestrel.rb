require 'formula'

class Kestrel < Formula
  url 'http://robey.github.com/kestrel/download/kestrel-2.1.4.zip'
  homepage 'http://robey.github.com/kestrel/'
  md5 '0859860deaf31e4031bfdaf618c812aa'

  depends_on 'daemon'

  def binfile
    return <<-EOBINFILE
#!/bin/sh
exec #{prefix}/scripts/kestrel.sh "$@"
EOBINFILE
  end

  def install

    inreplace 'scripts/kestrel.sh' do |s|
        s.gsub!(/\/usr\/local\/\$APP_NAME\/current/, "#{prefix}")
        s.gsub!(/\/var\/log\/\$APP_NAME/, "#{var}/log/$APP_NAME")
        s.gsub!(/\/var\/run\/\$APP_NAME/, "#{var}/run/$APP_NAME")
        s.gsub!(/\/etc\/init.d\/\$\{APP_NAME\}.sh/, "$0")
    end

    prefix.install Dir['*']
    (prefix+'scripts/kestrel.sh').chmod 0755
    (prefix+'scripts/devel.sh').chmod 0755

    (var+'log/kestrel').mkpath
    (var+'run/kestrel').mkpath

    (bin).mkpath
    (bin+'kestrel').write binfile
    (bin+'kestrel').chmod 0755
  end

  def test
      system "#{bin}/kestrel status"
  end
end
