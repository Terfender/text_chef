# Install rbenv and ruby
bash "Install rbenv and ruby" do
  code <<-EOF
    sudo apt-get install libav-tools
    sudo apt-get install libmagickcore-dev libmagickwand-dev libmagic-dev
    sudo apt-get install build-essential checkinstall && apt-get build-dep imagemagick -y

    cd /home/ubuntu
    sudo wget http://www.imagemagick.org/download/ImageMagick.tar.gz
    mkdir ImageMagick
    sudo tar xzvf ImageMagick.tar.gz -C /home/ubuntu/ImageMagick

    cd ImageMagick
    ./configure
    make clean
    make
    checkinstall
    ldconfig /usr/local/lib
    magick -version

  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})

end