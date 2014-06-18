function newReservationFormController(options) {
    this.options = $.extend({
    container: '',
    entities_controller_url: 'url to backend',
  }, options || {});


    this.formContainer = null;
    this.beginMoment = moment();
    this.endMoment = moment();
    this.entityTypeId = null;
    this.selectedEntityId = null;

    this.currentAvailableEntities = [];

    this.init();
};

newReservationFormController.prototype.init = function() {
  this.formContainer = $('#' + this.options.container);
  this.bindOnChangeActions();
  this.bindEntitySelection();

  this.performFormUpdate();
};

newReservationFormController.prototype.bindEntitySelection = function() {
  var _this = this;
  this.getAvailableEntitiesList().on('click', 'li', function() {
    selectedLi = $(this);
    _this.selectedEntityId = selectedLi.data('entity-id');
    _this.removeSelectedClassFromAvailableEntitiesListItems();
    selectedLi.addClass('selected');
    _this.setEntitySelection();
  });
};

newReservationFormController.prototype.setEntitySelection = function() {
  var selCont = this.formContainer.find('div.selected-entity');
  selCont.text(this.currentAvailableEntities[this.selectedEntityId].name);
  selCont.removeClass('available unavailable warning-available');
  selCont.addClass(this.currentAvailableEntities[this.selectedEntityId].warning ? 'warning-available' : 'available');

  // Set the hidden form field for the entity for this reservation
  this.formContainer.find('input#reservation_entity_id').val(this.selectedEntityId);

  this.setDefaultSlackTimes();
};

newReservationFormController.prototype.removeSelectedClassFromAvailableEntitiesListItems = function() {
  this.getAvailableEntitiesList().find('li').removeClass('selected');
};

newReservationFormController.prototype.setDefaultSlackTimes = function() {
  this.formContainer.find('input#reservation_slack_before').attr('placeholder', this.currentAvailableEntities[this.selectedEntityId].default_slack_before);
  this.formContainer.find('input#reservation_slack_after').attr('placeholder', this.currentAvailableEntities[this.selectedEntityId].default_slack_after);
};

newReservationFormController.prototype.bindOnChangeActions = function() {
  var _this = this;
  this.formContainer.find('input#begins_at_date, input#begins_at_tod, input#ends_at_date, input#ends_at_tod, select#entity_type_id').on('change', function() {
    _this.performFormUpdate.call(_this);
  });
};

newReservationFormController.prototype.performFormUpdate = function() {
  this.parseSelectedEntityFormField();
  if(this.parseBeginAndEndFromFormFields() && this.parseEntityTypeFormFields()) {
    this.updateAvailableEntities();
  }
};

newReservationFormController.prototype.parseSelectedEntityFormField = function() {
  var selE  = this.formContainer.find('input#reservation_entity_id').val();
  if($.isNumeric(selE)) {
    this.selectedEntityId = parseInt(selE, 10);
  } else {
    this.selectedEntityId = null;
  }
};

newReservationFormController.prototype.parseEntityTypeFormFields = function() {
  var entitySelector = this.formContainer.find('select#entity_type_id');
  if(entitySelector.val() != '') {
    this.entityTypeId = parseInt(entitySelector.val(), 10);
    return true;
  } else {
    this.clearAvailableEntitiesList();
  }
  return false;
};

newReservationFormController.prototype.parseBeginAndEndFromFormFields = function() {
  var beginsAtDateField = this.formContainer.find('input#begins_at_date');
  var beginsAtTodField = this.formContainer.find('input#begins_at_tod');
  var endsAtDateField = this.formContainer.find('input#ends_at_date');
  var endsAtTodField = this.formContainer.find('input#ends_at_tod');

  var beginValid = beginsAtDateField.val() != '' && beginsAtTodField.val() != '';

  var newBeginMoment = moment(beginsAtDateField.datepicker('getDate'));
  this.updateMomentWithTime(newBeginMoment, beginsAtTodField.timepicker('getTime'));

  beginValid = beginValid && newBeginMoment.isValid();
  if(beginValid) {
    this.beginMoment = newBeginMoment;
  }
  APP.util.setFieldErrorState(beginsAtDateField, !beginValid);
  APP.util.setFieldErrorState(beginsAtTodField, !beginValid);

  var endValid = endsAtDateField.val() != '' && endsAtTodField.val() != '';

  var newEndMoment = moment(endsAtDateField.datepicker('getDate'));
  this.updateMomentWithTime(newEndMoment, endsAtTodField.timepicker('getTime'));

  endValid = endValid && newEndMoment.isValid();
  if(endValid) {
    this.endMoment = newEndMoment;
  }
  APP.util.setFieldErrorState(endsAtDateField, !endValid);
  APP.util.setFieldErrorState(endsAtTodField, !endValid);

  return beginValid && endValid;
};

newReservationFormController.prototype.updateMomentWithTime = function(moment, timeString) {
  var hours = parseInt(timeString.split(':')[0], 10);
  var minutes = parseInt(timeString.split(':')[1], 10);
  moment.hours(hours);
  moment.minutes(minutes);
};

newReservationFormController.prototype.updateAvailableEntities = function() {
  var _this = this;
  $.ajax({
    type: 'POST',
    url: this.options.entities_controller_url + '/availability.json',
    data: {
      selected_entity_id: _this.selectedEntityId,
      entity_type_id: _this.entityTypeId,
      begins_at: _this.beginMoment.toJSON(),
      ends_at: _this.endMoment.toJSON()
    }
  }).success(function(response) {
    if(response.selected_entity_feedback) {
      _this.updateSelectedEntityFeedback(response.selected_entity_feedback);
    }
    _this.updateAvailableEntitiesList(response.entities);
  });
};

newReservationFormController.prototype.updateAvailableEntitiesList = function(entities) {
  var _this = this;
  this.clearAvailableEntitiesList();

  var entityList = this.getAvailableEntitiesList();
  $.each(entities, function(index, entity) {
    // Cache the entity info for later form settings during entity selection
    _this.currentAvailableEntities[entity.id] = entity;

    var newLi = $('<li>', {
      data: {
        entityId: entity.id
      },
      text: entity.name,
      css: {
        borderLeftColor: entity.color
      }
    });

    if(entity.id == _this.selectedEntityId) {
      newLi.addClass('selected');
    }

    if(entity.warning) {
      newLi.append($('<span>', { 'class': 'icon-warning-sign' }));
    }

    entityList.append(newLi);
  });
};

newReservationFormController.prototype.updateSelectedEntityFeedback = function(feedback) {
  var selCont = this.formContainer.find('div.selected-entity');
  selCont.removeClass('available warning-available unavailable');
  if(!feedback.available) {
    selCont.addClass('unavailable');
  } else if(feedback.warning) {
    selCont.addClass('warning-available');
  } else {
    selCont.addClass('available');
  }
};

newReservationFormController.prototype.clearAvailableEntitiesList = function() {
  this.getAvailableEntitiesList().html('');
};

newReservationFormController.prototype.getAvailableEntitiesList = function() {
  return this.formContainer.find('div.entity-selector ul.entity-list');
};
