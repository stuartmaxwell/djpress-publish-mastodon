# DJ Press Mastodon Publisher

A plugin for [DJ Press](https://pypi.org/project/djpress/) that automatically publishes your blog posts to your
Mastodon server. When you publish a new post on your Django blog, this plugin will create a corresponding post on your
Mastodon account with a customizable status message.

## Features

- 🚀 Automatic posting to Mastodon when blog posts are published
- 📝 Customizable post message
- ✅ Keeps track of posts that have already been posted to Mastodon, so you don't get multiple Mastodon posts

## Requirements

- Python >= 3.10
- Django >= 4.2
- DJ Press >= 0.12.1
- Mastodon.py >= 1.8.1

## Installation

1. Install the package using pip:

    ```bash
    pip install djpress-publish-mastodon
    ```

2. Add the plugin to your `DJPRESS_SETTINGS` in `settings.py`:

    ```python
    DJPRESS_SETTINGS = {
        # ... existing settings
        "PLUGINS": [
            # ... existing plugins
            "djpress_publish_mastodon",
        ]
    }
    ```

3. Add the plugin settings to your `DJPRESS_SETTINGS` in `settings.py`:

    ```python
    DJPRESS_SETTINGS = {
        # ... existing settings
        "PLUGIN_SETTINGS": {
            # ... existing plugins
            "djpress_publish_mastodon": {
                "instance_url": "https://mastodon.social",  # or the instance you are using
                "access_token": "...",  # or preferably load from an environment variable or secrets manager
                "status_message": "🚀 I created a new blog post!",  # keep this brief
                "base_url": "https://example.com",  # The base URL to your site
            }
        }
    }
    ```

## Configuration

### Getting Your Mastodon Access Token

1. Log into your Mastodon instance
2. Go to Preferences > Development
3. Click "New Application"
4. Give it a name (e.g., "My DJ Press Blog")
5. Select the following permissions:
   - `write:statuses`
6. Save and copy the access token into the `DJPRESS_SETTINGS`.

## Usage

Once configured, the plugin works automatically. When you publish a new blog post, it will be posted to your Mastodon
account using the configured message.

**Note** that a published post will only be published to Mastodon once - the first time it is saved and with
`is_published = True`. This plugin keeps track of which posts have been published to Mastodon and won't publish them
again. The list of published posts is stored in the plugin storage model.

## Troubleshooting

If posts aren't appearing on Mastodon:

1. Check the Django logs for error messages
2. Verify your access token is correct
3. Ensure the plugin is enabled in settings
4. Confirm your Mastodon instance URL is correct
5. Check that your posts are marked as published

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Credits

Created by Stuart Maxwell
Powered by [DJ Press](https://github.com/yourusername/djpress)
