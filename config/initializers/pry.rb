module Pry::RailsPromptDecorator
  extend self

  def set!(identifier = Rails.env)
    Pry.config.prompt_name = prompt_text(identifier)
  end

  def prompt_text(identifier)
    [
      (project_name || "pry"),
      colorize(identifier)
    ].join(":")
  end

  COLORS = {
    "production" => {color: :red, bold: true},
    "test" => {color: :yellow},
    "development" => {color: :blue}
  }

  def colorize(identifier)
    Pry::Helpers::Text.colorize(
      COLORS[identifier][:color],
      identifier,
      COLORS[identifier][:bold]
    )
  end

  def project_name
    if Rails::VERSION::MAJOR >= 6
      Rails.application.class.module_parent_name.underscore
    else
      Rails.application.class.parent_name.underscore
    end
  end
end

if Pry::Helpers::Text.respond_to?(:colorize)
  # You may remove this whole if block
  puts "DEPRECATION WARNING: Pry::Helpers::Text now responds to :colorize. "\
    "(called from #{__FILE__}:#{__LINE__})"
else
  module Pry::Helpers::Text
    def colorize(color, text, bold = false)
      text
      .then{ |it| bold ? bold(it) : it }
      .then{ |it| send(color, it) }
    end
  end
end

# See PryRails::Prompt
# Pry.config.prompt = Pry::Prompt[:rails]

Pry::RailsPromptDecorator.set!
