from urllib.parse import urljoin

from djpress.plugins import DJPressPlugin
from mastodon import Mastodon


class Plugin(DJPressPlugin):
    name = "djpress_publish_mastodon"

    def setup(self, registry):
        registry.register_hook("post_save_post", self.publish_post)

    def publish_post(self, post):
        # Get the settings from the config dictionary
        access_token = self.config.get("access_token")
        instance_url = self.config.get("instance_url")
        status_message = self.config.get("status_message")
        base_url = self.config.get("base_url")

        # Silently fail if any of the required config is missing
        if not access_token or not instance_url or not status_message or not base_url:
            return

        # We keep track of which posts have been published to Mastodon already by adding the post id to the data with a
        # key called "published_posts". This way we can check if the post has already been published to Mastodon.
        data = self.get_data()
        published_posts = data.get("published_posts", [])
        if post.id in published_posts:
            return

        try:
            mastodon = Mastodon(access_token=access_token, api_base_url=instance_url)

            post_content = (
                f"{status_message} {post.title} {urljoin(base_url, post.url)}"
            )

            mastodon.toot(post_content)

            published_posts.append(post.id)
            data["published_posts"] = published_posts
            self.save_data(data)
        except Exception:
            pass
