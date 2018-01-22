# Install API packages
bash "Install API packages" do
  code <<-EOF
    sudo apt-get install -y libav-tools libmagickcore-dev libmagickwand-dev libmagic-dev libpq-dev
    sudo apt-get install -y build-essential checkinstall && apt-get build-dep imagemagick

    MAGICK_PATH=$(which magick)

    if [[ $MAGICK_PATH = ""  ]]; then
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
    else
        echo magic exists
        echo $MAGICK_PATH
    fi

  EOF
  user "ubuntu"
  environment ({'HOME' => '/home/ubuntu'})

end