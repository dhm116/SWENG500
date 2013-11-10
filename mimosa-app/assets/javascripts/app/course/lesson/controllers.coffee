define ['angular'], (angular) ->
    return angular.module('djangoApp.controllers').controller 'LessonController',
        ($scope, $routeParams, Restangular, Course, Lesson, Assignment) ->

            if($routeParams.hasOwnProperty('lessonId'))
                Lesson.get(Number($routeParams.lessonId)).then (lesson) ->
                    $scope.lesson = lesson[0]
                    Course.get($scope.lesson.course).then (course) ->
                        $scope.course = course

                    Assignment.get($scope.lesson.assignments).then (assignments) ->
                        $scope.lesson.assignments = assignments
