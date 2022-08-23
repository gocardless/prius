# Prius
Environmentally-friendly application config for Ruby.

[![Gem Version](https://badge.fury.io/rb/prius.svg)](http://badge.fury.io/rb/prius)
[![Build Status](https://circleci.com/gh/gocardless/prius.svg?style=svg)](https://app.circleci.com/pipelines/github/gocardless/prius)

Prius helps you guarantee that your environment variables are:

- **Present** - an exception is raised if an environment variable is missing,
  so you can hear about it as soon as your app boots.
- **Valid** - an environment variable can be coerced to a desired type
  (integer, boolean or string), and an exception will be raised if the value
  doesn't match the type.

## Usage

#### Installing

```
$ gem install prius
```

#### Quick Start

```ruby
# Load a required environment variable into the Prius registry:
Prius.load(:github_token)

# Use the environment variable:
Prius.get(:github_token)

# Load an optional environment variable:
Prius.load(:might_be_here_or_not, required: false)

# Load and alias an environment variable:
Prius.load(:alias_name, env_var: "HORRENDOUS_SYSTEM_VAR_NAME")

# Load and coerce an environment variable (or raise):
Prius.load(:my_flag, type: :bool)
```

You probably want to `load` all your environment variables as your app starts,
so you catch config issues at boot time.

#### Loading Environment Variables

Environment variables need to be loaded into the Prius registry before being
used. Typically this is done in an initialiser.

```ruby
Prius.load(name, options = {})
```

If an environment variable can't be loaded, Prius will raise one of:
- `MissingValueError` if the environment variable was expected to be set but couldn't be found.
- `TypeMismatchError` if the environment variable wasn't of the expected type (see below).

`Prius.load` accepts the following options:

| Param             | Default       | Description                                                                               |
|-------------------|---------------|-------------------------------------------------------------------------------------------|
| `required`        | `true`        | Flag to require the environment variable to have been set.                                |
| `type`            | `:string`     | Type to coerce the environment variable to. Allowed values are `:string`, `:int` and `:bool`. |
| `env_var`         | `name.upcase` | Name of the environment variable name (if different from the upcased `name`).             |

#### Reading Environment Variables

Once a variable has been loaded into the registry it can be read using:

```ruby
Prius.get(name)
```

If the environment variable hasn't been loaded, Prius will raise an `UndeclaredNameError`.

#### Test and development environments

To make running your app in test and development environments easier we
recommend using [Dotenv](https://github.com/bkeepers/dotenv) to automatically
load a file of dummy config values.

---

GoCardless ♥ open source. If you do too, come [join us](https://gocardless.com/about/jobs/software-engineer).
