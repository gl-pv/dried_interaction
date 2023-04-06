# DriedInteraction

DriedInteraction is a simple gem that helps you write interactors with input params validation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dried_interaction'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dried_interaction

## Usage
### Setting up an interactor
For setting up an interactor you need to include DriedInteraction into your class.
Then you can add contract for call method which will validate input params.
By default interactor returns Dry::Matcher::ResultMatcher.

```rb
class PublishPost
  include DriedInteraction

  option :normalize_params, reader: :private, default: -> { PostParamsNormalize.new }
  option :post_repo, reader: :private, default: -> { PostRepo }
  option :notify, reader: :private, default: -> { PostNotify.new }

  contract do
    required(:user).filled(Dry.Types.Instance(User))
    required(:params).hash do
      required(:title).filled(:string)
      required(:content).filled(:string)
      optional(:public).filled(:bool)
    end
  end

  def call(user:, params:)
    normalized_params = yield normalize_params.call(params)
    post = yield save_post(normalized_params)
    notify.call(post)

    Success(post)
  end

  private

  def save_post(params)
    post = post_repo.new(params)
    post.save ? Success(post) : Failure('Error message')
  end
end
```

### Contract options
You can pass to contract some options which will customize contract logic.
1. `kind`. Explains which type of validator you will use.
Available values: `simple` (By default) and `extended`
`simple` kind uses simple `Dry::Schema.Params`
`extended` kind uses more complex `Dry::Validation.Contract`

```rb
  contract(kind: :simple) do ... end
  // or
  contract(kind: :extended) do ... end
```

2. `mode`. Explains how to handle contract validation errors.
Available values: `strict` (By default) and `soft`
`strict` mode raises exception when contract check fails.
`soft`  mode returns Failure monad with error info when contract check fails.

```rb
  contract(mode: :strict) do ... end // => raise DriedInteractionError
  // or
  contract(mode: :soft) do ... end // => returns Failure(DriedInteractionError)
```

### Interactor calling

```rb
PublishPost.new.call(user, params) do |interactor|
  interactor.success do |post|
    # handle success
  end

  interactor.failure do |error|
    # handle failure
  end
end
```

When you use `soft` mode you can handle contract failure as divided failure case:
```rb
  PublishPost.new.call(user, params) do |interactor|
  interactor.success do |post|
    # handle success
  end

  interactor.failure(DriedInteractionError) do |error|
    #  handle contract validation error
  end

  interactor.failure do |error|
    # handle failure
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
