# ElectricEye

A network video recorder for multiple IP cameras using VLC.

## History

I've been using Zoneminder & motion and these programs are either too large for my requirements (zoneminder) or don't work with the cameras I own (motion). What I did notice is all my cameras work through VLC with high resolution and VLC can record. 

The problem was though VLC doesn't automate the recordings or handle the file structure nicely. This is where I started to think about creating an application which records from VLC and nicely sorts those recordings in directories by date & time.

## Requirements

- VLC
- ruby
- Linux (Tested on Debian 7)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'electric_eye'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install electric_eye

## Configuration

Enter your cameras into the JSON config file like so

```yaml
---
duration: 60
path: "/media/data/recordings/temp"
cameras:
- :name: Reception
  :url: rtsp://<user>:<passwd>@<camera's ip>/live2.sdp
- :name: Kitchen
  :url: rtsp://<user>:<passwd>@<camera's ip>/live2.sdp
- :name: Workstations
  :url: rtsp://<user>:<passwd>@<camera's ip>/live2.sdp
```

You should be able to view the URL through vlc before using this program.

The recordings directory will end up with these directories

    /media/data/recordings/reception/20150527
    /media/data/recordings/kitchen/20150527

Notice the date at the end of these paths, there will be one for each day. The contents within will be recordings which are done by default every 10minutes, example;

    20150527-1020-reception.mjpeg
    20150527-1030-reception.mjpeg
    20150527-1040-reception.mjpeg

The default is going to be 10 minute blocks, this can be overridden with the duration variable above in minutes.

## Usage

First make sure you add your cameras

    electric_eye add Reception <url>

Now start the daemon to start the recording process

    electric_eye start

Stop all recordings

    electric_eye stop

Usage in development mode

    bundle exec bin/electric_eye -h


## Cleanup

Cleaning up recordings. Put the following into your /etc/crontab per recording directory.

    00 19	* * *	root	/usr/bin/find <directory to recordings> -type f -mtime +<days> -exec rm {} \;

Example for cleaning up reception after 60days at 7pm everynight.

    00 19	* * *	root	/usr/bin/find /media/recordings/reception -type f -mtime +60 -exec rm {} \;

## Contributing

1. Fork it ( https://github.com/map7/electric_eye/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## TODO

- Adjust directory layout
- Turn into a gem
- Add testing
- Add motion detection (using [rmotion](https://github.com/rikiji/rmotion))
- Do inline motion detection (using activevlc)
- Allow different recording programs like raspicam

