module LinkHelper
  # Link helper for default links to scaffold (CRUD) pages
  # Link to object helpers
  def link_to_index(object, options = {})
    name = options.delete(:name) || t('.to_index', default: :to_index_objects, classes: object_classes_name(object).lcfirst)
    location = options.delete(:location) || polymorphic_path(object)
    options = options.merge(data: { action: 'index' })
    link_to_if(can?(:index, relevant_object(object)), name, location, options) {}
  end

  def link_to_new(object, options = {})
    name =  options.delete(:name) || t('.to_new', default: :to_new_object, class: object_class_name(object).lcfirst)
    location = options.delete(:location) || new_polymorphic_path(object)
    options = options.merge(data: { action: 'new' })
    link_to_if(can?(:new, relevant_object(object)), name, location, options) {}
  end

  def link_to_show(object, options = {})
    name = options.delete(:name) || t('.to_show', default: :to_show_object, class: object_class_name(object).lcfirst, name: object_name(object))
    location = options.delete(:location) || object
    options = options.merge(data: { action: 'show' })
    link_to_if(can?(:show, relevant_object(object)), name, location, options)
  end

  def link_to_edit(object, options = {})
    name = options.delete(:name) || t('.to_edit', default: :to_edit_object, class: object_class_name(object).lcfirst, name: object_name(object))
    location = options.delete(:location) || edit_polymorphic_path(object)
    options = options.merge(data: { action: 'edit' })
    link_to_if(can?(:edit, relevant_object(object)), name, location, options) {}
  end

  def link_to_destroy(object, options = {})
    name = options.delete(:name) || t('.to_destroy', default: :to_destroy_object, class: object_class_name(object).lcfirst, name: object_name(object))
    location = options.delete(:location) || object
    confirm = options.delete(:confirm) || t('.to_destroy_confirm', default: :to_destroy_object_confirm, class: object_class_name(object).lcfirst, name: object_name(object))
    options = options.merge(method: :delete, data: { confirm: confirm, action: 'destroy' })
    link_to_if(can?(:destroy, relevant_object(object)), name, location, options) {}
  end

  # Link back to object helpers
  def link_back_to_index(object, options = {})
    options[:name] ||= t('.back_to_index', default: :back_to_index_objects, classes: object_classes_name(object).lcfirst)
    link_to_index(object, options)
  end

  def link_back_to_show(object, options = {})
    options[:name] ||= t('.back_to_show', default: :back_to_show_object, class: object_class_name(object).lcfirst, name: object_name(object))
    link_to_show(object, options)
  end

  # Name link to object helpers
  def name_link_to_show(object, options = {})
    options[:name] ||= object_name(object)
    options[:title] ||= t('.to_show', default: :to_show_object, class: object_class_name(object).lcfirst, name: object_name(object))
    link_to_show(object, options)
  end

  # Icon link to object helpers
  def icon_link_to_edit(object, options = {})
    options[:name] = ''
    options[:class] ||= 'icon icon-edit'
    options[:title] ||= t('.to_edit', default: :icon_to_edit_object, class: object_class_name(object).lcfirst, name: object_name(object))
    link_to_edit(object, options)
  end

  def icon_link_to_destroy(object, options = {})
    options[:name] = ''
    options[:class] ||= 'icon icon-remove'
    options[:title] ||= t('.to_destroy', default: :icon_to_destroy_object, class: object_class_name(object).lcfirst, name: object_name(object))
    link_to_destroy(object, options)
  end

  # Button link to object helpers
  def button_link_to_index(object, options = {})
    options[:class] ||= 'button'
    link_to_index(object, options)
  end

  def button_link_to_new(object, options = {})
    options[:class] ||= 'button'
    link_to_new(object, options)
  end

  def button_link_to_show(object, options = {})
    options[:class] ||= 'button'
    link_to_show(object, options)
  end

  def button_link_to_edit(object, options = {})
    options[:class] ||= 'button'
    link_to_edit(object, options)
  end

  def button_link_to_destroy(object, options = {})
    options[:class] ||= 'button'
    link_to_destroy(object, options)
  end

  # Button link back to object helpers
  def button_link_back_to_index(object, options = {})
    options[:class] ||= 'button'
    link_back_to_index(object, options)
  end

  def button_link_back_to_show(object, options = {})
    options[:class] ||= 'button'
    link_back_to_show(object, options)
  end

private
  # Helpers for the link helpers
  def relevant_object(object)
    case object
    when Array
      object.last
    when Hash
      relevant_object(object.values.last)
    else
      object
    end
  end

  def relevant_class(object)
    object = relevant_object(object)
    case object
    when Class
      object
    else
      object.class
    end
  end

  def object_classes_name(object)
    relevant_class(object).model_name.human(count: 2)
  end

  def object_class_name(object)
    relevant_class(object).model_name.human
  end

  def object_name(object)
    relevant_object(object).instance_name
  end
end