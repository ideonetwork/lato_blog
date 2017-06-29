module LatoBlog
  module FieldsHelper

    # This function render the partial used to render post fields for a
    # specific post.
    def render_post_fields(post)
      post_fields = post.post_fields.visibles.roots
      render 'lato_blog/back/posts/fields/fields', post_fields: post_fields
    end

    # This function render a single post field.
    def render_post_field(post_field, key_parent = 'fields')
      # define key
      key = "#{key_parent}[#{post_field.key}]"
      # render correct field
      case post_field.typology
      when 'text'
        render_post_field_text(post_field, key)
      when 'image'
        render_post_field_image(post_field, key)
      when 'composed'
        render_post_field_composed(post_field, key)
      when 'relay'
        render_post_field_relay(post_field, key)
      end
    end

    # Specific field render functions:
    # **************************************************************************

    # Text.
    def render_post_field_text(post_field, key)
      render 'lato_blog/back/posts/fields/single_fields/text', post_field: post_field, key: key
    end

    # Image.
    def render_post_field_image(post_field, key)
      render 'lato_blog/back/posts/fields/single_fields/image', post_field: post_field, key: key
    end

    # Composed.
    def render_post_field_composed(post_field, key)
      render 'lato_blog/back/posts/fields/single_fields/composed', post_field: post_field, key: key
    end

    # Relay.
    def render_post_field_relay(post_field, key)
      render 'lato_blog/back/posts/fields/single_fields/relay', post_field: post_field, key: key
    end

  end
end