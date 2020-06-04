<%@page import="org.springframework.security.core.GrantedAuthority"%>
<%@page import="java.util.Collection"%>
<%@page import="org.springframework.security.core.context.SecurityContextHolder"%>
<%@page import="org.springframework.security.core.Authentication"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Points</title>
        <jsp:include page="meta.jsp" />
        <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="https://www.jeasyui.com/easyui/themes/color.css">
        
        <script type="text/javascript" src="https://www.jeasyui.com/easyui/jquery.easyui.min.js"></script>
    </head>
    <body>
        <jsp:include page="header.jsp" />
        <div class="d-flex justify-content-center">
            <span class="align-middle" style="margin-top: 50px; width: 1000px;">
                <table id="dgPoints" class="easyui-datagrid" style="height:500px;width:1000px" 
                       data-options="rownumbers:false,singleSelect:true,autoRowHeight:false,
                       toolbar:'#tbPoints',pageSize:100,url:'points/getList?username=${username}'">
                    <thead>
                        <tr>
                            <th data-options="field:'name',align:'left',width:'35%',sortable:true"><center>Name</center></th>
                            <th data-options="field:'address',align:'center',width:'35%',sortable:true"><center>Address</center></th>
                            <th data-options="field:'type',align:'center',width:'35%',sortable:true,formatter:formatType"><center>Type</center></th>
                        </tr>
                    </thead>
                </table>

                <div id="tbPoints" style="padding:5px;height:auto">
                    <div style="margin-bottom:5px">
                        <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="recNew()" style="width:40px" title="Add"></a>
                        <a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="recDelete()" style="width:40px" title="Delete"></a>
                        <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="recEdit()" style="width:40px" title="Edit"></a>
                        <span style="margin-right: 5px">Point name: </span><input class="text" style="width:100px; height: 30px" id="name" >
                        <span style="margin-left: 10px; margin-right: 10px;">Address: </span><input class="text" style="width:100px; height: 30px" id="address" >
                        <span style="margin-left: 10px; margin-right: 10px;">Type: </span>
                        <select style="width:100px; height: 30px" id="type" onchange="recSearch()">
                            <option value="0">All</option>
                            <option value="1">Waste recycling</option>
                            <option value="2">Bicycle rental</option>
                            <option value="3">Eco cafe</option>
                        </select>
                        <a href="#" class="easyui-linkbutton" iconCls="icon-search"  plain="true" style="float:right;width:40px" onclick="recSearch()" title="Search"></a>
                    </div>
                </div> 
            </span>
        </div>
        
        <!-- Modal -->
        <div class="modal fade" id="delModal" role="dialog">
          <div class="modal-dialog modal-dialog-centered">

            <!-- Modal content-->
            <div class="modal-content">
              <div class="modal-header">
                <h4 class="modal-title">Delete record</h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
              </div>
              <div class="modal-body">
                <p id="modalText">Some text in the modal.</p>
              </div>
              <div class="modal-footer">
                <button id="btnConfirm" type="button" class="btn btn-outline-success" data-dismiss="modal">Submit</button>
                <button type="button" class="btn btn-outline-secondary" data-dismiss="modal">Close</button>
              </div>
            </div>

          </div>
        </div>
    </body>
    
    <script>
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                recSearch('Users');
                recSearch('Points');
            }
        });
        
        $('#dgPoints').datagrid({ onDblClickCell: function(index,field,value){ recEdit(); }});
        
        $(document).ready(function() {
            recSearch('Users');
            recSearch('Points');
        });
        
        function recNew() {
            window.location.href = "points/edit";
        }

        function recEdit() {
            var id = $('#dgPoints').datagrid('getSelected').id;

            if (id > 0) {
                window.location.href = "points/edit?id=" + id;
            } else {
                alert("No selected records!");
            }
        }

        function recDelete() {
            var row = $('#dgPoints').datagrid('getSelected');

            if (row) {
                $('#modalText').text("Delete " + row.name + "?");
                $('#btnConfirm').click( function () { recDeleting(row.id) });
                $('#delModal').modal();
            } else {
                alert("No selected records!");
            }
        }

        function recDeleting(id) {
            if (id > 0) {
                fetch("points/delete?id=" + id)
                    .then(response => recSearch());
            }
        }
        
        function recSearch() {
            var f = {};
            f.username = $('#username').val();
            f.type = $('#type').val();
            f.name = $('#name').val();
            f.address = $('#address').val();
            
            $('#dgPoints').datagrid('load', f);
        }
        
        function formatType(val,row) {
            if (val === 1) val = "Waste recycling";
            if (val === 2) val = "Bicycle rental";
            if (val === 3) val = "Eco cafe";
            return val; 
        }
        
        function formatUsername(val,row) {
            return row.user.username;; 
        }
    </script>
</html>
