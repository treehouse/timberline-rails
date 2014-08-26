# Timberline-Rails

![](https://travis-ci.org/treehouse/timberline-rails.svg)&nbsp;
[![Gem Version](https://badge.fury.io/rb/timberline-rails.svg)](http://badge.fury.io/rb/timberline-rails)

## Purpose

Timberline-Rails adds some extra functionality to
[Timberline](https://github.com/treehouse/timberline) to make it easier to use
in the context of a Rails application.

## What's New

### Configuration

In base Timberline, you have a few options for configuration, from defining a
`TIMBERLINE_YAML` constant that points to a yaml config file to defining the
configuration in code using `Timberline.configure`. Timberline-Rails adds in
automatic detection for a config file at `config/timberline.yml` in your Rails
app, complete with environment support (just like database.yml).

### Timberline::Rails::ActiveRecord and Timberline::Rails::ActiveRecordWorker

In order to make running jobs in the background as easy as possible,
Timberline-Rails comes with two new items to help:

#### Timberline::Rails::ActiveRecord

This is a module that you can include in your ActiveRecord models to give you
an easy DSL for marking certain methods to always run in the background.

Example:

    class User < ActiveRecord::Model
      include Timberline::Rails::ActiveRecord
      
      # specify the queue for jobs to run on
      timberline_queue "user_jobs"

      def send_some_email
        ...
      end
      # Now whenever send_some_email gets called, we put a message onto the "user_jobs" queue
      # rather than calling the method directly.
      delay_method :send_some_email
    end

#### Timberline::Rails::ActiveRecordWorker

This is a worker designed to parse messages put on a queue by Timberline::Rails::ActiveRecord.
To continue our example from above:

    # run this script with rails/runner or use some other means to load your Rails environment
    
    Timberline::Rails::ActiveRecordWorker.new.watch("user_jobs")

...and items will be pulled off of the `user_jobs` queue and processed (in this case,
we'll look up the appropriate User record and call `#send_some_email` on it directly).=

## Usage

Timberline-Rails works exactly like Timberline; just make sure that you have
`timberline-rails` listed in your Gemfile and you're good to go.

## Contributions

If Timberline-Rails interests you and you think you might want to contribute,
hit me up over Github. You can also just fork it and make some changes, but
there's a better chance that your work won't be duplicated or rendered obsolete
if you check in on the current development status first.

## Development notes

You need Redis installed to do development on Timberline-Rails, and currently the test
suites assume that you're using the default configurations for Redis. That
should probably change, but it probably won't until someone needs it to.

Gem requirements/etc. should be handled by Bundler.

## License
Copyright (C) 2014 by Tommy Morgan

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
