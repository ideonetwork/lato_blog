module LatoBlog
  module PostField::SerializerHelpers

    # This function serializes a basic version of the post field.
    def serialize_base
      serialized = {}

      # set basic info
      serialized[:key] = key
      serialized[:typology] = typology
      serialized[:value] = serialize_field_value

      # return serialized post
      serialized
    end

    private

    # Serializer field value:
    # **************************************************************************

    # This function serialize the field value of the post field.
    def serialize_field_value
      case typology
      when 'text'
        serialize_field_value_text
      when 'textarea'
        serialize_field_value_textarea
      when 'datetime'
        serialize_field_value_datetime
      when 'editor'
        serialize_field_value_editor
      when 'geolocalization'
        serialize_field_value_geolocalization
      when 'image'
        serialize_field_value_image
      when 'gallery'
        serialize_field_value_gallery
      when 'youtube'
        serialize_field_value_youtube
      when 'composed'
        serialize_field_value_composed
      when 'relay'
        serialize_field_value_relay
      end
    end

    # Serializer specific field value:
    # **************************************************************************

    # Text.
    def serialize_field_value_text
      value
    end

    # Textarea.
    def serialize_field_value_textarea
      value
    end

    # Datetime.
    def serialize_field_value_datetime

      begin
        date = DateTime.parse(value)
        serialized = {}

        serialized[:datetime] = date
        serialized[:year] = date.year
        serialized[:month] = date.month
        serialized[:day] = date.day
        serialized[:hour] = date.hour
        serialized[:minute] = date.min
        serialized[:second] = date.sec
      rescue StandardError
        serialized = {}
      end
      # return serialized data
      serialized
    end

    # Editor.
    def serialize_field_value_editor
      value
    end

    # Geolocalization.
    def serialize_field_value_geolocalization
      return unless value
      value_object = eval(value)
      serialized = {}

      # add basic info
      serialized[:latitude] = value_object[:lat]
      serialized[:longitude] = value_object[:lng]
      serialized[:address] = value_object[:address]

      # return serialized data
      serialized
    end

    # Image.
    def serialize_field_value_image
      media = LatoMedia::Media.find_by(id: value)
      return unless media

      # add basic info
      serialized = {}
      serialized[:id] = media.id
      serialized[:title] = media.title
      serialized[:url] = media.attachment.url

      # add image info
      serialized[:thumb_url] = (media.image? ? media.attachment.url(:thumb) : nil)
      serialized[:medium_url] = (media.image? ? media.attachment.url(:medium) : nil)
      serialized[:large_url] = (media.image? ? media.attachment.url(:large) : nil)

      # return serialized media
      serialized
    end

    # Gallery.
    def serialize_field_value_gallery
      media_ids = value.split(',')
      medias = LatoMedia::Media.where(id: media_ids)
      return unless medias

      # add basic info
      serialized = []

      medias.each do |media|
        serialized_media = {}
        serialized_media[:id] = media.id
        serialized_media[:title] = media.title
        serialized_media[:url] = media.attachment.url

        # add image info
        serialized_media[:thumb_url] = (media.image? ? media.attachment.url(:thumb) : nil)
        serialized_media[:medium_url] = (media.image? ? media.attachment.url(:medium) : nil)
        serialized_media[:large_url] = (media.image? ? media.attachment.url(:large) : nil)

        serialized.push(serialized_media)
      end

      # return serialized media
      serialized
    end

    # Youtube.
    def serialize_field_value_youtube
      value
    end

    # Composed.
    def serialize_field_value_composed
      serialized = {}
      post_fields.visibles.order('position ASC').each do |post_field|
        serialized[post_field.key] = post_field.serialize_base
      end
      serialized
    end

    # Relay.
    def serialize_field_value_relay
      serialized = []
      post_fields.visibles.order('position ASC').each do |post_field|
        serialized.push(post_field.serialize_base)
      end
      serialized
    end

  end
end
