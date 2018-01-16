# Install rbenv and ruby
bash "Install rbenv and ruby" do
  code <<-EOF
    sudo apt-get install -y libav-tools

    sudo apt-get install -y libmagickcore-dev libmagickwand-dev libmagic-dev

    sudo apt-get install -y build-essential checkinstall && apt-get build-dep imagemagick

    cd /home/ubuntu
    rm -rf ImageMagick*
    mkdir ImageMagick
    sudo wget http://www.imagemagick.org/download/ImageMagick.tar.gz
    sudo tar xzvf ImageMagick.tar.gz -C /home/ubuntu/ImageMagick --strip-components=1

    cd ImageMagick
    sudo ./configure
    sudo make clean
    sudo make
    sudo checkinstall
    sudo sh -c "ldconfig /usr/local/lib"
    magick -version

  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})

end