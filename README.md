# Prius
Environmentally-friendly application config for Ruby.

[BADGES]

To install with RubyGems:

```
$ gem install hutch
```

## Overview

Environment variables are fiddly.
It's easy to forget them, forget to set their values or end up with inconsistent formats for booleans and flags.

Prius makes it easy to provide a few guarantees around your environment variables which make them easier to work with.

- **They're present** - environment variables must have been be loaded into the Prius registry before they can be used. If they haven't, it will raise an error
- **They're consistently typed** - if you expect an environment variable to be an integer or a boolean, prius can attempt to coerce it (e.g. `y => true`). If it can't, it'll raise an error.
- **They're easy to refer to** - so often environment variables have long and complex names, Prius makes it easy to assign them more code-friendly names

## Usage

#### Quick Start

```ruby
# Load a required environment variable into the Prius registry:
Prius.load(:github_token)

# Use the environment variable:
Prius.get(:github_token)

# Load an optional enviroment variable:
Prius.load(:might_be_here_or_not, required: false)

# Load and alias an environment variable
Prius.load(:alias_name, env_var: "HORRENDOUS_SYSTEM_VAR_NAME")

# Load and coerce an environment variable
Prius.load(:my_flag, type: :bool)
# e.g. If MY_FLAG is one of y/yes/1/t/true
# Prius.get(:my_flag) => true
```

#### Loading Environment Variables

To load environment variables for use with Prius, you must first load them
into the Prius registry using:

```ruby
Prius.load(name, env_var: nil, type: :string, allow_nil: false)
```

| Param             | default       | Description                                                                               |
|-------------------|---------------|-------------------------------------------------------------------------------------------|
| `name`            |               | The way you will refer to the prius config variable                                       |
| `env_var`         | `name.upcase` | The environment variable name                                                         |
| `type`            | `:string`     | Attempts to coerce the type of the environment variable. For example, if set to `:bool`, `yes`, `y`, `true`, `t` and `1` would all be coerced to `true`.                               |
| `allow_nil`       | `false`         | Whether to raise an error if the environment variable hasn't been set. |

In the case where an environment variable cannot be loaded, Prius will raise one of:

| Error              | Description                                                                               |
|--------------------|-----------------------------------------------------------------------------------------------------------
| `MissingValueError` | The enviroment variable was expected to be set, but it couldn't be found
| `TypeMismatchError` | The enviroment variable wasn't of the expected type (e.g. "foo", where an integer was expected)

#### Using Environment Variables

Variables must be loaded into the registry before being used, but once loaded, they can be read using a call to:

```ruby
Prius.get(name)
```

In the case where an environment variable hasn't been loaded, Prius will raise an `UndeclaredNameError`.
