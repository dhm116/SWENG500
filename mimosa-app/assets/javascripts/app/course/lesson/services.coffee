define ['angular'], (angular) ->
    angular.module('djangoApp.services').factory 'Lesson', ($q, Course, Restangular) ->
        class Lesson
            lessons: []

            get: (ids) =>
                d = $q.defer()

                if typeof ids is 'string'
                    ids = [ids]

                unless @lessons.length
                    console.log "Loading course lessons"
                    Restangular.all('lessons').getList().then (lessons) =>
                        @lessons = lessons
                        d.resolve(@__getLesson(ids))
                else
                    d.resolve(@__getLesson(ids))
                return d.promise

            __getLesson: (ids) =>
                return _.filter @lessons, (lesson) =>
                    _.contains(ids, lesson.id)


        return new Lesson()
