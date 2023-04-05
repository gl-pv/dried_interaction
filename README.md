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

## Why it may be useful to you
1. Keeps your business logic typed
2. Validates interactor input data by default
3. Includes incredible DRY stack gems by default for yours interactors

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

## Additional info

1. You have to return a monad from interactor as result.
2. Contract failure will be handled as exception.

## Contributing

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
