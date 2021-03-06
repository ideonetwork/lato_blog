module LatoBlog
  class Back::PostFieldsController < Back::BackController

    before_action do
      core__set_menu_active_item('blog_articles')
    end

    def index
      core__set_header_active_page_title(LANGUAGES[:lato_blog][:pages][:post_fields])
      @post_fields = LatoBlog::PostField.all.order('meta_visible')
      @widget_index_post_fields = core__widgets_index(@post_fields, search: 'key', pagination: 10)
    end

    def destroy
      @post_field = LatoBlog::PostField.find_by(id: params[:id])

      unless @post_field
        flash[:warning] = LANGUAGES[:lato_blog][:flashes][:post_field_not_found]
        redirect_to lato_blog.root_path
        return
      end

      unless @post_field.destroy
        flash[:danger] = @post_field.category_parent.errors.full_messages.to_sentence
        redirect_to lato_blog.post_fields_path
        return
      end

      flash[:success] = LANGUAGES[:lato_blog][:flashes][:post_field_destroy_success]
      redirect_to lato_blog.post_fields_path
    end

    # Single fields endpoints:
    # **************************************************************************

    # This function create a new field for the post.
    def create_relay_field
      # find post field
      @post_field = LatoBlog::PostField.find_by(id: params[:post_field_id])
      unless @post_field
        @error = true
        respond_to { |r| r.js }
      end
      # find subfield info
      child_field_info = nil
      @post_field.meta_datas[:fields].each do |key, content|
        child_field_info = [key, content] if key == params[:key]
      end
      unless child_field_info
        @error = true
        respond_to { |r| r.js }
      end
      # prepare data to create field
      child_field_key = child_field_info.first
      child_field_content = child_field_info.last
      # override class and position
      child_field_content[:class] = nil
      child_field_content[:position] = !@post_field.post_fields.empty? ? @post_field.post_fields.order('position ASC').last.position + 1 : 1
      # create subfield for the post field
      blog__create_db_post_field(@post_field.post, child_field_key, child_field_content, @post_field)
      # send response to client
      @error = false
      respond_to { |r| r.js }
    end

    # This function destroy a post for the field.
    def destroy_relay_field
      # find post field
      child_field = LatoBlog::PostField.find_by(id: params[:id])
      @post_field = child_field.post_field
      unless @post_field
        @error = true
        respond_to { |r| r.js }
      end
      # find post field child and destroy it
      unless child_field.destroy
        @error = true
        respond_to { |r| r.js }
      end
      # send response to client
      @error = false
      respond_to { |r| r.js }
    end

  end
end
