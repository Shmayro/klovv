<!DOCTYPE html>
<html lang="en" ng-app="Klov">
<#include 'partials/head.ftl'>
<#setting time_zone="UTC">
<style>
    .border-box > h6 {
        margin-bottom: 0px;
    }

    .border-box {
        border: 1px solid rgba(120, 130, 140, .7);
        border-left: 2px solid rgba(120, 130, 140, .7);
        border-radius: .25rem;
        background-color: rgba(120, 130, 140, .2);
    }

    .border-box[status='fail'], .border-box[status='fatal'] {
        border: 1px solid #ff9a9a;
        border-left: 2px solid #ff9a9a;
        background-color: #ff9a9a20;
    }

    .border-box[status='skip'], .border-box[status='warning'] {
        border: 1px solid #fffbdd;
        border-left: 2px solid #fffbdd;
        background-color: #fffbdd20;
    }

    .border-box[status='error'] {
        border: 1px solid rgba(227, 180, 208, .7);
        border-left: 2px solid rgba(227, 180, 208, .7);
        background-color: rgba(227, 180, 208, .2);
    }

    .border-box[status='warning'] {
        border: 1px solid #fffbdd;
        border-left: 2px solid #fffbdd;
        background-color: #fffbdd20;
    }

    .border-box[status='pass'] {
        border: 1px solid #b5d6a7;
        border-left: 2px solid #b5d6a7;
        background-color: #b5d6a720;
    }

    .node.pass {
        background-color: #aed581;
    }

    .node.skip, .node.warning {
        background-color: #ff7043;
    }

    .node.fail, .node.error, .node.fatal {
        background-color: #e57373;
    }

    .bdd-node, .bdd-node h6, .bdd-node p, .bdd-node span:not(.label) {
        font-size: .9rem !important;
    }

    td.status-cell {
        width: 75px;
    }

    th {
        font-size: .75rem;
    }

    .table > thead > tr > th:first-child, .table > tbody > tr > td:first-child {
        padding-left: 0;
    }

    .sl-item {
        padding-top: 10px;
    }

    pre, .code-block {
        background-color: #f8f9fa;
        border: 1px solid #ebedef;
        border-radius: 4px;
        color: #222 !important;
        font-family: Consolas, monospace;
        font-size: 13px;
        margin: 0;
        padding: 7px 10px;
        white-space: pre-wrap;
    }
</style>
<body>
<div class="app report-page" id="app">
    <#include 'partials/sidenav.ftl'>
    <!-- content -->
    <div id="content" class="app-content box-shadow-z2 bg pjax-container" role="main" ng-controller="TestController"
         ng-init="findTest('${test.id}', false, false)">
        <div class="app-body">
            <!-- ############ PAGE START-->
            <div class="app-body-inner">
                <div class="row-col">
                    <div class="col-xs-3 modal fade aside aside-lg" id="subnav">
                        <div class="row-col black b-r bg">
                            <div class="b-b">
                                <div class="navbar no-radius">
                                    <!-- link and dropdown -->
                                    <ul class="nav navbar-nav">
                                        <li class="nav-item">
                                            <span class="navbar-item m-r-0 text-md">${test.name}</span>
                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link">
													<span class="label warn rounded">
													${testHistory?size} items
													</span>
                                            </a>
                                        </li>
                                    </ul>
                                    <!-- / link and dropdown -->
                                </div>
                            </div>
                            <!-- test list -->
                            <div class="row-row">
                                <div class="row-body scrollable hover">
                                    <div class="row-inner">
                                        <!-- left content -->
                                        <div class="list" data-ui-list="b-r b-2x b-theme">
                                            <!-- TEST SUMMARY -->
                                            <#list testHistory as t>
                                                <#assign warn="">
                                                <#if t.id == test.id>
                                                    <#assign warn="warn">
                                                </#if>

                                                <div class="list-item">
                                                    <div class="list-body">
                                                        <div class="pull-right">
                                                            <span class="label ${Color.byStatus(t.status)}">${t.status}</span>
                                                        </div>
                                                        <div class="item-title"
                                                             ng-click="findTest('${t.id}', false, false)">
                                                            <a href="#" class="_500">${t.startTime?datetime}</a>
                                                        </div>
                                                        <div class="pull-right">
                                                            <span class="label blue-grey"><i
                                                                        class="fa fa-clock-o"></i> <#if (t.duration)??>${t.duration?number_to_time?string["HH'h 'mm'm 'ss's+'sss'ms'"]}<#else>0ms</#if></span>
                                                        </div>
                                                        <small class="block text-ellipsis">
																<span class="text-xs">
																<#if (t.duration)??>
                                                                    ${t.duration?string}
                                                                <#else>
                                                                    0
                                                                </#if>
																</span> <span class="text-muted">ms</span>
                                                        </small>
                                                        <small class="block text-ellipsis text-xs"
                                                               style="margin-top:4px;">
                                                            <a href="#" class="text-xs label lhs ${warn}"
                                                               ng-click="findTest('${t.id}', false, false)">1</a>
                                                            <a href="#" class="text-xs label rhs"
                                                               ng-click="findTest('${t.id}', true, false)">2</a>
                                                        </small>
                                                    </div>
                                                </div>
                                            </#list>
                                            <!-- / TEST SUMMARY -->
                                        </div>
                                        <!-- / -->
                                    </div>
                                </div>
                            </div>
                            <!-- / -->
                        </div>
                    </div>
                    <div class="col-xs-4 modal fade aside aside-sm" id="list">
                        <div class="row-col b-r light lt">
                            <div class="b-b">
                                <div class="navbar no-radius">
                                    <a data-toggle="modal" data-target="#subnav" data-ui-modal
                                       class="navbar-item pull-left hidden-xl-up hidden-sm-down">
											<span class="btn btn-sm btn-icon blue">
											<i class="fa fa-th"></i>
											</span>
                                    </a>
                                    <!-- link and dropdown -->
                                    <ul class="nav navbar-nav">
                                        <li class="nav-item">
                                            <span class="navbar-item m-r-0 text-sm">{{currentTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}} {{currentTest.id}}</span>
                                        </li>
                                    </ul>
                                    <!-- / link and dropdown -->
                                </div>
                            </div>
                            <!-- flex content -->
                            <div class="row-row">
                                <div class="row-body scrollable hover">
                                    <div class="row-inner">

                                        <!-- if this is a bdd report -->
                                        <#if isBDD>
                                            <div class="p-a" ng-if="currentTest">
                                                <!-- PARENT -->
                                                <h4><small class="_600" ng-if="currentTest.bddType">{{currentTest.bddType}}:</small>
                                                    {{currentTest.name}}</h4>
                                                <span class="label teal">{{currentTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
                                                <span class="label brown">{{currentTest.endTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
                                                <span class="label {{getColor(currentTest.status)}}">{{currentTest.status}}</span>
                                                <div ng-if="currentTest.categorized">
                                                    <span class="label blue-grey"
                                                          ng-repeat="category in currentTest.categoryNameList"><i
                                                                class="fa fa-tag"></i> &nbsp; {{category}}</span>
                                                </div>

                                                <br/>

                                                <!-- parent nodes -->
                                                <div class="bdd-node" ng-if="currentTest.nodes.length">
                                                    <!-- node1 -->
                                                    <div class="p-a box light border-box"
                                                         ng-repeat="node1 in currentTest.nodes">
                                                        <p ng-if="node1.categorized">
                                                            <span class="label blue-grey"
                                                                  ng-repeat="category in node1.categoryNameList"><i
                                                                        class="fa fa-tag"></i> &nbsp; {{category}}</span>
                                                        </p>

                                                        <h6><small class="_600"
                                                                   ng-if="node1.bddType">{{node1.bddType}}:</small>
                                                            {{node1.name}}</h6>

                                                        <!-- node1 logs -->
                                                        <div class="list-group m-b log" ng-if="node1.logs"
                                                             ng-repeat="log in node1.logs">
                                                            <p class="list-group-item b-l-{{getBootstrapColor(log.status)}}"
                                                               ng-bind-html="trust(log.details)">
                                                            </p>
                                                            <p class="list-group-item b-l-{{getBootstrapColor(log.status)}}"
                                                               ng-if="log.media" ng-repeat="m in log.media">
                                                                <a href="data:image/png;base64,{{m.base64String}}"
                                                                   data-featherlight="image">
                                                                    <span class="label info">img</span>
                                                                </a>
                                                            </p>
                                                        </div>

                                                        <!-- node1 media -->
                                                        <div class="row">
                                                            <div class="col-sm-4 media" ng-if="node1.media"
                                                                 ng-repeat="m in node1.media">
                                                                <div ng-if="m.base64String" class="box p-a">
                                                                    <a href="data:image/png;base64,{{m.base64String}}"
                                                                       data-featherlight="image">
                                                                        <img class="img-responsive"
                                                                             src="data:image/png;base64,{{m.base64String}}">
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- node1 nodes -->
                                                        <div ng-if="node1.nodes.length">
                                                            <!-- nodes -->
                                                            <div ng-repeat="node2 in node1.nodes"
                                                                 ng-class="node2.status" class="node p-a">
                                                                <h6><small class="_600" ng-if="node2.bddType">{{node2.bddType}}:</small>
                                                                    {{node2.name}}</h6>

                                                                <!-- node2 logs -->
                                                                <div class="log" ng-if="node2.logs"
                                                                     ng-repeat="log in node2.logs">
                                                                    <span ng-bind-html="trust(log.details)"></span>
                                                                    <a ng-if="log.media" ng-repeat="m in log.media"
                                                                       href="data:image/png;base64,{{m.base64String}}"
                                                                       data-featherlight="image">
																				<span class="label">
																					<i class="fa fa-image"></i>
																				</span>
                                                                    </a>
                                                                </div>

                                                                <!-- node2 media -->
                                                                <div ng-if="node2.media && !m.log"
                                                                     ng-repeat="m in node2.media"
                                                                     href="data:image/png;base64,{{m.base64String}}"
                                                                     data-featherlight="image">
																			<span class="label">
																				<i class="fa fa-image"></i>																		
																			</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </#if>

                                        <#if !isBDD>
                                            <div class="p-a" ng-if="currentTest">
                                                <!-- PARENT -->
                                                <h4><small class="_600">{{currentTest.name}}</small></h4>
                                                <span class="label teal">{{currentTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
                                                <span class="label brown">{{currentTest.endTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
                                                <span class="label {{getColor(currentTest.status)}}">{{currentTest.status}}</span>
                                                <div class="pull-right">
                                                    <span ng-if="currentTest.categorized" class="label blue-grey"
                                                          ng-repeat="category in currentTest.categoryNameList"><i
                                                                class="fa fa-tag"></i> &nbsp; {{category}}</span>
                                                    <span class="label blue"><i class="fa fa-clock-o"></i> {{currentTest.duration | date: "H'h 'mm'm 'ss's+'sss'ms'" : "UTC"}}</span>
                                                </div>
                                                <br/>
                                                <br/>

                                                <div class="streamline" ng-if="currentTest.logs">
                                                    <div ng-repeat="log in currentTest.logs"
                                                         class="sl-item b-{{getBootstrapColor(log.status)}}">
                                                        <div class="sl-icon">
                                                            <i class="fa fa-{{getFont(log.status)}}"></i>
                                                        </div>
                                                        <div class="sl-content">
                                                            <div class="sl-date text-muted">{{getTime(log.timestamp)}}
                                                            </div>
                                                            <div ng-bind-html="trust(log.details)"></div>
                                                            <a ng-if="log.media" ng-repeat="m in log.media"
                                                               href="data:image/png;base64,{{m.base64String}}"
                                                               data-featherlight="image">
                                                                <span class="label">img</span>
                                                            </a>
                                                            <div>&nbsp;</div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- parent media -->
                                                <a ng-if="currentTest.media" ng-repeat="m in currentTest.media"
                                                   href="data:image/png;base64,{{m.base64String}}"
                                                   data-featherlight="image">
                                                    <span class="label">img</span>
                                                </a>

                                                <!-- parent nodes -->
                                                <div class="" ng-if="currentTest.nodes.length">
                                                    <!-- node1 -->
                                                    <div class="p-a box border-box light"
                                                         ng-repeat="(keyNode1,node1) in currentTest.nodes"
                                                         status="{{node1.status}}">
																<span class="pull-right lh-zero">
																	<span class="label blue-grey"><i
                                                                                class="fa fa-clock-o"></i>  {{node1.duration | date: "ss's+'sss'ms'" : "UTC"}}</span>
																	<span class="label {{getColor(node1.status)}}">{{node1.status}}</span>
																</span>
                                                        <h6 class="_600" data-toggle="collapse" href="#log1{{keyNode1}}"
                                                            role="button" aria-expanded="false"
                                                            aria-controls="log1{{keyNode1}}"><i
                                                                    class="fa fa-chevron-down"></i> {{node1.name}}</h6>

                                                        <div id="screens1{{keyNode1}}" ng-if="node1.logs">
                                                            <div ng-repeat-start="log in node1.logs"
                                                                 ng-if="false"></div>
                                                            <pre ng-if="log.details.length>100">{{getErrorResume(log.details)}}</pre>
                                                            <div ng-if="log.details.length>100"
                                                                 ng-bind-html="trust(getErrorScreen(log.details))"></div>
                                                            <div ng-repeat-end ng-if="false"></div>
                                                        </div>

                                                        <!-- node1 logs -->
                                                        <div class="streamline collapse" ng-if="node1.logs"
                                                             id="log1{{keyNode1}}" aria-expanded="false">
                                                            <hr/>
                                                            <div ng-repeat="log in node1.logs"
                                                                 class="sl-item b-{{getBootstrapColor(log.status)}}">
                                                                <div class="sl-icon">
                                                                    <i class="fa fa-{{getFont(log.status)}}"></i>
                                                                </div>
                                                                <div class="sl-content">
                                                                    <div class="sl-date text-muted">
                                                                        {{getTime(log.timestamp)}}
                                                                    </div>
                                                                    <div ng-bind-html="trust(log.details)"></div>
                                                                    <a ng-if="log.media" ng-repeat="m in log.media"
                                                                       href="data:image/png;base64,{{m.base64String}}"
                                                                       data-featherlight="image">
                                                                        <span class="label">img</span>
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- node1 media -->
                                                        <span class="label" ng-if="node1.media"
                                                              ng-repeat="m in node1.media" style="margin-right: 5px;">
																	<i class="fa fa-image"></i>
																	<a ng-if="m.base64String"
                                                                       href="data:image/png;base64,{{m.base64String}}"
                                                                       data-featherlight="image"></a>
																</span>

                                                        <!-- node1 nodes -->
                                                        <div class="p-a" ng-if="node1.nodes.length">
                                                            <!-- nodes -->
                                                            <div ng-repeat="(keyNode2,node2) in node1.nodes"
                                                                 status="{{node1.status}}">
																		<span class="pull-right lh-zero">
																			<span class="label blue-grey"><i
                                                                                        class="fa fa-clock-o"></i>  {{node2.duration | date: "ss's+'sss'ms'" : "UTC"}}</span>
																			<span class="label {{getColor(node2.status)}}">{{node2.status}}</span>
																		</span>
                                                                <h6 class="_600" data-toggle="collapse"
                                                                    href="#log2{{keyNode2}}" role="button"
                                                                    aria-expanded="false"
                                                                    aria-controls="log2{{keyNode2}}"><i
                                                                            class="fa fa-chevron-down"></i>
                                                                    {{node2.name}}</h6>

                                                                <div id="screens2{{keyNode2}}" ng-if="node2.logs">
                                                                    <div ng-repeat-start="log in node2.logs"
                                                                         ng-if="false"></div>
                                                                    <pre ng-if="log.details.length>100">{{getErrorResume(log.details)}}</pre>
                                                                    <div ng-if="log.details.length>100"
                                                                         ng-bind-html="trust(getErrorScreen(log.details))"></div>
                                                                    <div ng-repeat-end ng-if="false"></div>
                                                                </div>

                                                                <!-- node2 logs -->
                                                                <div class="streamline collapse" ng-if="node2.logs"
                                                                     id="log1{{keyNode2}}" aria-expanded="false">
                                                                    <hr/>
                                                                    <div ng-repeat="log in node2.logs"
                                                                         class="sl-item b-{{getBootstrapColor(log.status)}}">
                                                                        <div class="sl-icon">
                                                                            <i class="fa fa-{{getFont(log.status)}}"></i>
                                                                        </div>
                                                                        <div class="sl-content">
                                                                            <div class="sl-date text-muted">
                                                                                {{getTime(log.timestamp)}}
                                                                            </div>
                                                                            <div ng-bind-html="trust(log.details)"></div>
                                                                            <a ng-if="log.media"
                                                                               ng-repeat="m in log.media"
                                                                               href="data:image/png;base64,{{m.base64String}}"
                                                                               data-featherlight="image">
                                                                                <span class="label">img</span>
                                                                            </a>
                                                                            <div>&nbsp;</div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- node2 media -->
                                                                <span class="label" ng-if="node2.media"
                                                                      ng-repeat="m in node2.media"
                                                                      style="margin-right: 5px;">
																			<i class="fa fa-image"></i>
																			<a ng-if="m.base64String"
                                                                               href="data:image/png;base64,{{m.base64String}}"
                                                                               data-featherlight="image"></a>
																		</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </#if>
                                    </div>
                                </div>
                            </div>
                            <!-- / -->
                            <!-- footer -->
                            <!-- / -->
                        </div>
                    </div>
                    <div class="col-xs-4" id="detail">
                        <div class="row-col white b-r">
                            <div class="b-b">
                                <div class="navbar no-radius">
                                    <!-- nabar right -->
                                    <ul class="nav navbar-nav pull-right m-l">
                                        <li class="nav-item dropdown" ng-if="historicalList.length">
                                            <a class="nav-link">
													<span class="label warn rounded">
													{{historicalList.length}} items
													</span>
                                            </a>
                                        </li>
                                    </ul>
                                    <!-- / navbar right -->
                                    <a data-toggle="modal" data-target="#subnav" data-ui-modal
                                       class="navbar-item pull-left hidden-md-up">
											<span class="btn btn-sm btn-icon blue">
											<i class="fa fa-th"></i>
											</span>
                                    </a>
                                    <a data-toggle="modal" data-target="#list" data-ui-modal
                                       class="navbar-item pull-left hidden-md-up">
											<span class="btn btn-sm btn-icon btn-default">
											<i class="fa fa-list"></i>
											</span>
                                    </a>
                                    <span class="navbar-item text-sm text-ellipsis">{{historicalTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}} {{historicalTest.id}}</span>
                                </div>
                            </div>
                            <!-- flex content -->
                            <div class="row-row">
                                <div class="row-body scrollable hover">
                                    <div class="row-inner">

                                        <!-- if this is a bdd report -->
                                        <#if isBDD>
                                            <div class="p-a" ng-if="historicalTest">
                                                <!-- PARENT -->
                                                <h4><small class="_600" ng-if="historicalTest.bddType">{{historicalTest.bddType}}:</small>
                                                    {{historicalTest.name}}</h4>
                                                <span class="label teal">{{historicalTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
                                                <span class="label brown">{{historicalTest.endTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
                                                <span class="label {{getColor(historicalTest.status)}}">{{historicalTest.status}}</span>
                                                <div class="pull-right">
                                                    <span ng-if="historicalTest.categorized" class="label blue-grey"
                                                          ng-repeat="category in historicalTest.categoryNameList"><i
                                                                class="fa fa-tag"></i> &nbsp; {{category}}</span>
                                                    <span class="label blue"><i class="fa fa-clock-o"></i> {{historicalTest.duration | date: "H'h 'mm'm 'ss's+'sss'ms'" : "UTC"}}</span>
                                                </div>
                                                <br/>
                                                <br/>

                                                <!-- parent nodes -->
                                                <div class="bdd-node" ng-if="historicalTest.nodes.length">
                                                    <!-- nodeH1 -->
                                                    <div class="p-a box border-box"
                                                         ng-repeat="nodeH1 in historicalTest.nodes">
                                                        <p ng-if="nodeH1.categorized">
                                                            <span class="label blue-grey"
                                                                  ng-repeat="category in nodeH1.categoryNameList"><i
                                                                        class="fa fa-tag"></i> &nbsp; {{category}}</span>
                                                        </p>

                                                        <h6><small class="_600" ng-if="nodeH1.bddType">{{nodeH1.bddType}}:</small>
                                                            {{nodeH1.name}}</h6>

                                                        <!-- nodeH1 logs -->
                                                        <div class="list-group m-b log" ng-if="nodeH1.logs"
                                                             ng-repeat="log in nodeH1.logs">
                                                            <p class="list-group-item b-l-{{getBootstrapColor(log.status)}}"
                                                               ng-bind-html="trust(log.details)">
                                                            </p>
                                                            <p class="list-group-item b-l-{{getBootstrapColor(log.status)}}"
                                                               ng-if="log.media" ng-repeat="m in log.media">
                                                                <a href="data:image/png;base64,{{m.base64String}}"
                                                                   data-featherlight="image">
                                                                    <span class="label info">img</span>
                                                                </a>
                                                            </p>
                                                        </div>

                                                        <!-- nodeH1 media -->
                                                        <div class="row">
                                                            <div class="col-sm-4 media" ng-if="nodeH1.media"
                                                                 ng-repeat="m in nodeH1.media">
                                                                <div ng-if="m.base64String" class="box p-a">
                                                                    <a href="data:image/png;base64,{{m.base64String}}"
                                                                       data-featherlight="image">
                                                                        <img class="img-responsive"
                                                                             src="data:image/png;base64,{{m.base64String}}">
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- nodeH1 nodes -->
                                                        <div ng-if="nodeH1.nodes.length">
                                                            <!-- nodes -->
                                                            <div ng-repeat="nodeH2 in nodeH1.nodes"
                                                                 ng-class="nodeH2.status" class="node p-a">
                                                                <h6><small class="_600" ng-if="nodeH2.bddType">{{nodeH2.bddType}}:</small>
                                                                    {{nodeH2.name}}</h6>

                                                                <!-- nodeH2 logs -->
                                                                <div class="log" ng-if="nodeH2.logs"
                                                                     ng-repeat="log in nodeH2.logs">
                                                                    <span ng-bind-html="trust(log.details)"></span>
                                                                    <a ng-if="log.media" ng-repeat="m in log.media"
                                                                       href="data:image/png;base64,{{m.base64String}}"
                                                                       data-featherlight="image">
																				<span class="label">
																					<i class="fa fa-image"></i>
																				</span>
                                                                    </a>
                                                                </div>

                                                                <!-- nodeH2 media -->
                                                                <div ng-if="nodeH2.media && !m.log"
                                                                     ng-repeat="m in nodeH2.media"
                                                                     href="data:image/png;base64,{{m.base64String}}"
                                                                     data-featherlight="image">
																			<span class="label">
																				<i class="fa fa-image"></i>																		
																			</span>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </#if>

                                        <#if !isBDD>
                                            <div class="p-a" ng-if="historicalTest">
                                                <!-- PARENT -->
                                                <h4><small class="_600">{{historicalTest.name}}</small></h4>
                                                <span class="label teal">{{historicalTest.startTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
                                                <span class="label brown">{{historicalTest.endTime | date: 'MMM dd, yyyy hh:mm:ss'}}</span>
                                                <span class="label {{getColor(historicalTest.status)}}">{{historicalTest.status}}</span>
                                                <div class="pull-right">
                                                    <span ng-if="historicalTest.categorized" class="label blue-grey"
                                                          ng-repeat="category in historicalTest.categoryNameList"><i
                                                                class="fa fa-tag"></i> &nbsp; {{category}}</span>
                                                    <span class="label blue"><i class="fa fa-clock-o"></i> {{historicalTest.duration | date: "H'h 'mm'm 'ss's+'sss'ms'" : "UTC"}}</span>
                                                </div>
                                                <br/>
                                                <br/>

                                                <div class="streamline" ng-if="historicalTest.logs">
                                                    <div ng-repeat="log in historicalTest.logs"
                                                         class="sl-item b-{{getBootstrapColor(log.status)}}">
                                                        <div class="sl-icon">
                                                            <i class="fa fa-{{getFont(log.status)}}"></i>
                                                        </div>
                                                        <div class="sl-content">
                                                            <div class="sl-date text-muted">{{getTime(log.timestamp)}}
                                                            </div>
                                                            <div ng-bind-html="trust(log.details)"></div>
                                                            <a ng-if="log.media" ng-repeat="m in log.media"
                                                               href="data:image/png;base64,{{m.base64String}}"
                                                               data-featherlight="image">
                                                                <span class="label">img</span>
                                                            </a>
                                                            <div>&nbsp;</div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- parent media -->
                                                <a ng-if="historicalTest.media" ng-repeat="m in historicalTest.media"
                                                   href="data:image/png;base64,{{m.base64String}}"
                                                   data-featherlight="image">
                                                    <span class="label">img</span>
                                                </a>

                                                <!-- parent nodes -->
                                                <div class="" ng-if="historicalTest.nodes.length">
                                                    <!-- nodeH1 -->
                                                    <div class="p-a box border-box"
                                                         ng-repeat="(keyNodeH1,nodeH1) in historicalTest.nodes"
                                                         status="{{nodeH1.status}}">
																<span class="pull-right lh-zero">
																	<span class="label blue-grey"><i
                                                                                class="fa fa-clock-o"></i>  {{nodeH1.duration | date: "ss's+'sss'ms'" : "UTC"}}</span>
																	<span class="label {{getColor(nodeH1.status)}}">{{nodeH1.status}}</span>
																</span>
                                                        <h6 class="_600" data-toggle="collapse"
                                                            href="#logH1{{keyNodeH1}}" role="button"
                                                            aria-expanded="false" aria-controls="logH1{{keyNodeH1}}"><i
                                                                    class="fa fa-chevron-down"></i> {{nodeH1.name}}</h6>

                                                        <div id="screens1{{keyNodeH1}}" ng-if="nodeH1.logs">
                                                            <div ng-repeat-start="log in nodeH1.logs"
                                                                 ng-if="false"></div>
                                                            <pre ng-if="log.details.length>100">{{getErrorResume(log.details)}}</pre>
                                                            <div ng-if="log.details.length>100"
                                                                 ng-bind-html="trust(getErrorScreen(log.details))"></div>
                                                            <div ng-repeat-end ng-if="false"></div>
                                                        </div>

                                                        <!-- nodeH1 logs -->
                                                        <div class="streamline collapse" ng-if="nodeH1.logs"
                                                             id="logH1{{keyNodeH1}}" aria-expanded="false">
                                                            <hr/>
                                                            <div ng-repeat="log in nodeH1.logs"
                                                                 class="sl-item b-{{getBootstrapColor(log.status)}}">
                                                                <div class="sl-icon">
                                                                    <i class="fa fa-{{getFont(log.status)}}"></i>
                                                                </div>
                                                                <div class="sl-content">
                                                                    <div class="sl-date text-muted">
                                                                        {{getTime(log.timestamp)}}
                                                                    </div>
                                                                    <div ng-bind-html="trust(log.details)"></div>
                                                                    <a ng-if="log.media" ng-repeat="m in log.media"
                                                                       href="data:image/png;base64,{{m.base64String}}"
                                                                       data-featherlight="image">
                                                                        <span class="label">img</span>
                                                                    </a>
                                                                </div>
                                                            </div>
                                                        </div>

                                                        <!-- nodeH1 media -->
                                                        <span class="label" ng-if="nodeH1.media"
                                                              ng-repeat="m in nodeH1.media" style="margin-right: 5px;">
																	<i class="fa fa-image"></i>
																	<a ng-if="m.base64String"
                                                                       href="data:image/png;base64,{{m.base64String}}"
                                                                       data-featherlight="image"></a>
																</span>

                                                        <!-- nodeH1 nodes -->
                                                        <div class="p-a" ng-if="nodeH1.nodes.length">
                                                            <!-- nodes -->
                                                            <div ng-repeat="(keyNodeH2,nodeH2) in nodeH1.nodes">
                                                                <span class="label {{getColor(nodeH2.status)}} pull-right">{{nodeH2.status}}</span>
                                                                <h6 class="_600" data-toggle="collapse"
                                                                    href="#logH2{{keyNodeH2}}" role="button"
                                                                    aria-expanded="false"
                                                                    aria-controls="logH2{{keyNodeH2}}"><i
                                                                            class="fa fa-chevron-down"></i>
                                                                    {{nodeH2.name}}</h6>

                                                                <!-- nodeH2 logs -->
                                                                <div class="streamline collapse" ng-if="nodeH2.logs"
                                                                     id="logH2{{keyNodeH2}}" aria-expanded="false">
                                                                    <div ng-repeat="log in nodeH2.logs"
                                                                         class="sl-item b-{{getBootstrapColor(log.status)}}">
                                                                        <div class="sl-icon">
                                                                            <i class="fa fa-{{getFont(log.status)}}"></i>
                                                                        </div>
                                                                        <div class="sl-content">
                                                                            <div class="sl-date text-muted">
                                                                                {{getTime(log.timestamp)}}
                                                                            </div>
                                                                            <div ng-bind-html="trust(log.details)"></div>
                                                                            <a ng-if="log.media"
                                                                               ng-repeat="m in log.media"
                                                                               href="data:image/png;base64,{{m.base64String}}"
                                                                               data-featherlight="image">
                                                                                <span class="label">img</span>
                                                                            </a>
                                                                            <div>&nbsp;</div>
                                                                        </div>
                                                                    </div>
                                                                </div>

                                                                <!-- nodeH2 media -->
                                                                <span class="label" ng-if="nodeH2.media"
                                                                      ng-repeat="m in nodeH2.media"
                                                                      style="margin-right: 5px;">
																			<i class="fa fa-image"></i>
																			<a ng-if="m.base64String"
                                                                               href="data:image/png;base64,{{m.base64String}}"
                                                                               data-featherlight="image"></a>
																		</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </#if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- ############ PAGE END-->
        </div>
    </div>
    <!-- / -->
    <#include 'partials/switcher.ftl'>
    <!-- ############ LAYOUT END-->
</div>
<#include 'partials/scripts.ftl'>
<#include 'partials/angular.ftl'>

<script>
    $(document).ready(function () {
        $("#detail").hide();
        $("#list").removeClass("col-xs-4");
        $("#list").addClass("col-xs-8");

        $(".lhs, .rhs").fadeOut();

        $("#subnav").hover(function () {
            $(".lhs, .rhs").fadeIn(100);
        }, function () {
            $(".lhs, .rhs").fadeOut(100);
        });

        $(".lhs").click(function () {
            $(".lhs").removeClass("warn");
            $(this).addClass("warn");
        })
        $(".rhs").click(function () {
            $(".rhs").removeClass("warn");
            $(this).addClass("warn");
            $('#detail').show();
            $("#list").removeClass("col-xs-8");
            $("#list").addClass("col-xs-4");
        })
    });
</script>
</body>
</html>