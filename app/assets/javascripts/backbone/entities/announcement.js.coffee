@Balances.module 'Entities', (Entities, App, Backbone, Marionette, $, _) ->

  ##############################################################################
  # Models
  ##############################################################################

  class Entities.Announcement extends Entities.Model
    markAsRead: (options = {}) ->
      _.defaults options,
        url: Routes.announcement_mark_as_read_path @id
      @save {mark_as_read: true}, options


  ##############################################################################
  # Collections
  ##############################################################################

  class Entities.Announcements extends Entities.Collection
    model: Entities.Announcement
    url: -> Routes.announcements_path()
