require 'formula'

class YoutubeUpload < Formula
  url 'https://youtube-upload.googlecode.com/files/youtube-upload-0.7.tgz'
  homepage ''
  md5 '161c10a1442aa135f9ce65c15864b432'

  def install
        system "python setup.py config"
        system "python setup.py install"
  end

  def test
    # This test will fail and we won't accept that! It's enough to just
    # replace "false" with the main program this formula installs, but
    # it'd be nice if you were more thorough. Test the test with
    # `brew test youtube-upload`. Remove this comment before submitting
    # your pull request!
    system "youtube-upload --help"
    system "youtube-upload --get-categories"
  end
end
