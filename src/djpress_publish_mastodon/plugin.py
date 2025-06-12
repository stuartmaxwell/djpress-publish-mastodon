from typing import TYPE_CHECKING
from urllib.parse import urljoin

from djpress.plugins import DJPressPlugin
from djpress.plugins.hook_registry import POST_SAVE_POST
from mastodon import Mastodon

if TYPE_CHECKING:
    from djpress.models import Post


class Plugin(DJPressPlugin):
    name = "djpress_publish_mastodon"
    hooks = [(POST_SAVE_POST, "publish_post")]

    def publish_post(self, post: "Post") -> "Post":
        # Get the settings from the settings dictionary
        access_token = self.settings.get("access_token")
        instance_url = self.settings.get("instance_url")
        status_message = self.settings.get("status_message")
        base_url = self.settings.get("base_url")

        # Silently fail if any of the required config is missing
        if not access_token or not instance_url or not status_message or not base_url:
            return post

        # We keep track of which posts have been published to Mastodon already by adding the post id to the data with a
        # key called "published_posts". This way we can check if the post has already been published to Mastodon.
        data = self.get_data()
        published_posts = data.get("published_posts", [])
        if post.pk in published_posts:
            return post

        try:
            mastodon = Mastodon(access_token=access_token, api_base_url=instance_url)

            post_content = f"{status_message} {post.post_title} {urljoin(base_url, post.url)}"

            mastodon.toot(post_content)

            published_posts.append(post.pk)
            data["published_posts"] = published_posts
            self.save_data(data)
        except Exception:
            pass

        return post
