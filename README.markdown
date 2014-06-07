# Timberline-Rails

![](https://travis-ci.org/treehouse/timberline-rails.svg)

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

## Usage

Timberline-Rails works exactly like Timberline; just make sure that you have
`timberline-rails` listed in your Gemfile and you're good to go.

## TODO

Still to be done:

- **Rails Workers** - implement workers that expect to operate on ActiveRecord objects
  so you can quickly and easily background tasks in Rails.

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
