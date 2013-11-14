define ['angular'], (angular) ->
    return angular.module('djangoApp.controllers').controller 'LessonController',
        ($scope, $routeParams, $location, Restangular, User, Course, Lesson, Assignment) ->

            # if($routeParams.hasOwnProperty('courseId'))
            #     Course.get(Number($routeParams.courseId)).then (course) ->
            #         $scope.course = course
            console.log "Lesson Controller", $routeParams

            Course.get(Number($routeParams.parentId)).then (course) ->
                $scope.course = course

            unless $routeParams.action.indexOf('add') is 0
                Lesson.get(Number($routeParams.id)).then (lesson) ->
                    $scope.lesson = lesson
                    console.log "This lesson has these assignments: ", $scope.lesson.assignments
                    if _.every($scope.lesson.assignments, _.isNumber)
                        Assignment.all($scope.lesson.assignments).then (assignments) ->
                            $scope.lesson.assignments = assignments
            else if $routeParams.action.indexOf('add') is 0
                $scope.lesson = {course:$routeParams.parentId, author: User.data.id}

            # if($routeParams.hasOwnProperty('action'))
            #     if $routeParams.action is 'edit'

            $scope.undo = ->
                if $scope.original_lesson
                    $scope.lesson = Restangular.copy($scope.original_lesson)

            $scope.save = ->
                if $routeParams.action.indexOf("edit") is 0
                    console.log "Saving lesson changes: ", $scope.lesson
                    Lesson.update($scope.lesson)
                        .then (result) ->
                            console.log "Save worked: ", result
                            # $scope.course.lessons.push result
                            $location.path("/course/view/#{$scope.course.id}/lesson/view/#{result.id}")
                        .catch (err) ->
                            console.log "Save failed: ", err
                else if $routeParams.action.indexOf('add') is 0
                    console.log "Saving new Lesson: ", $scope.lesson
                    Lesson.add($scope.lesson)
                        .then (result) ->
                            console.log "Adding worked: ", result
                            $scope.course.lessons.push result
                            $location.path("/course/view/#{$scope.course.id}/lesson/view/#{result.id}")
                        .catch (err) ->
                            console.log "Adding failed: ", err