prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.05.31'
,p_release=>'24.1.0'
,p_default_workspace_id=>78327024425781225
,p_default_application_id=>300
,p_default_id_offset=>0
,p_default_owner=>'EDTECH_DI'
);
end;
/
 
prompt APPLICATION 300 - DIT Trainer
--
-- Application Export:
--   Application:     300
--   Name:            DIT Trainer
--   Date and Time:   13:03 Thursday October 24, 2024
--   Exported By:     ANIELS08
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 198826809471168579
--   Manifest End
--   Version:         24.1.0
--   Instance ID:     204289999079057
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/region_type/ca_insum_plugin_boilerplate_region
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(198826809471168579)
,p_plugin_type=>'REGION TYPE'
,p_name=>'CA.INSUM.PLUGIN.BOILERPLATE.REGION'
,p_display_name=>'Insum Region Plug-in Boilerplate'
,p_javascript_file_urls=>'#PLUGIN_FILES#js/insumRegionBP#MIN#.js'
,p_css_file_urls=>'#PLUGIN_FILES#css/insumRegionCss#MIN#.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- output_clob',
'-- Accepts a clob and calls htp.prn to output the clob to the browser.',
'-- Note: htp.prn does not add line breaks. The region_html function should add',
'--       chr(10) or chr(13) at appropriate locations to make the output html readable',
'procedure output_clob(p_clob    in clob) is',
'k_chunk_size    constant    pls_integer := 32767;',
'l_offset                    pls_integer := 1;',
'l_clob                      clob;',
'l_clob_chunk                varchar2(32767);',
'begin',
'    loop',
'        l_clob_chunk := substr(p_clob, l_offset, k_chunk_size);',
'        exit when l_clob_chunk is null;',
'        htp.prn(l_clob_chunk);',
'        l_offset := l_offset + k_chunk_size;',
'    end loop;',
'end output_clob;',
'',
'-- region_html',
'-- The content of the region should be generated here.',
'-- Note: the output_clob procedure uses htp.prn which does not add line breaks. ',
'--       The region_html function should add',
'--       chr(10) or chr(13) at appropriate locations to make the output html readable',
'function region_html(    ',
'    p_plugin in            apex_plugin.t_plugin,',
'    p_region in            apex_plugin.t_region',
'    ) return clob is',
'l_html                      clob;',
'l_items_to_submit           p_region.ajax_items_to_submit%type := replace(p_region.ajax_items_to_submit, '' '', null);',
'l_column_value_list         apex_plugin_util.t_column_value_list;',
'begin',
'    ',
'    l_html := ''<p>You submitted the following items:'' || chr(10) || ''<ul>'' || chr(10);',
'',
'    for i in (select column_value item_name from apex_string.split(l_items_to_submit,'',''))',
'    loop',
'        l_html := l_html || ''<li>'' || apex_escape.html(i.item_name || '': '' || v(i.item_name)) || ''</li>'' || chr(10);',
'    end loop;',
'',
'    l_html := l_html || ''</ul></p>'';',
'',
'-- example code for showing output from a query',
'/*',
'    l_column_value_list := apex_plugin_util.get_data ( p_sql_statement => p_region.source, ',
'                                                       p_min_columns => 1, ',
'                                                       p_max_columns => 50, ',
'                                                       p_component_name => p_region.name);',
'',
'',
'    l_html := l_html || ''<table>'';',
'    for i in 1..l_column_value_list(1).count loop',
'        l_html := l_html || ''<tr>'';',
'        l_html := l_html || ''<td>'' || l_column_value_list(1)(i) || ''</td>'';',
'        l_html := l_html || ''<td>'' || l_column_value_list(2)(i) || ''</td>'';',
'        l_html := l_html || ''<td>'' || l_column_value_list(3)(i) || ''</td>'';',
'        l_html := l_html || ''</tr>'' || chr(10);',
'    end loop;',
'    l_html := l_html || ''</table>'';',
'*/',
'',
'    return l_html;',
'',
'end region_html;',
'',
'-- render',
'-- This is the main render procedure. It does very little. The main code is in region_html.',
'-- This function handles region initialization and lazy loading only.',
'procedure render(',
'    p_plugin in            apex_plugin.t_plugin,',
'    p_region in            apex_plugin.t_region,',
'    p_param  in            apex_plugin.t_region_render_param,',
'    p_result in out nocopy apex_plugin.t_region_render_result ) is',
'',
'l_html                      clob;',
'l_esc_static_id             varchar2(4000) := apex_escape.html(p_region.static_id);',
'l_ajax_id                   varchar2(4000) := apex_plugin.get_ajax_identifier;',
'l_items_to_submit           p_region.ajax_items_to_submit%type := replace(p_region.ajax_items_to_submit, '' '', null);',
'l_lazy_load_yn              varchar2(8) := apex_escape.html(p_region.attributes.get_varchar2(''lazy_load_yn'')); ',
'l_init_code                 varchar2(32767);',
'begin',
'    apex_plugin_util.debug_region (',
'        p_plugin         => p_plugin,',
'        p_region         => p_region);',
'',
'    -- this div is isolated from region_html to support lazy loading',
'    l_html := ''<div id="'' || l_esc_static_id ||''-plugin'' || ''" class ="insumRegionClass">'';',
'',
'    if l_lazy_load_yn = ''N'' then',
'        l_html := l_html || region_html(',
'                     p_plugin => p_plugin,',
'                     p_region => p_region',
'                     );',
'    end if;             ',
'',
'    l_html := l_html || ''</div>'';             ',
'',
'    if l_items_to_submit is not null then',
'        l_items_to_submit :=  ''#'' || replace(l_items_to_submit,'','','',#'');',
'    end if;',
'',
'    l_init_code := ''insumInitMyRegion( "'' || l_esc_static_id || ''","'' || l_ajax_id || ''","'' || l_items_to_submit || ''");'';',
'',
'    if l_lazy_load_yn = ''Y'' then',
'        l_init_code := l_init_code || '' apex.region("'' || l_esc_static_id ||''").refresh();'';',
'    end if;',
'',
'    apex_javascript.add_onload_code (',
'        p_code => l_init_code,',
'        p_key  => ''insumInitMyRegionKey-'' || l_esc_static_id);',
'',
'    output_clob(l_html);',
'',
'end render;',
'',
'-- ajax_callback',
'-- This is the ajax_callback procedure. It does very little. The main code is in region_html.',
'procedure ajax_callback (',
'    p_plugin in            apex_plugin.t_plugin,',
'    p_region in            apex_plugin.t_region,',
'    p_param  in            apex_plugin.t_region_ajax_param,',
'    p_result in out nocopy apex_plugin.t_region_ajax_result ) is',
'',
'l_html              clob;',
'l_esc_static_id     varchar2(4000) := apex_escape.html(p_region.static_id);',
'l_ajax_id           varchar2(4000) := apex_plugin.get_ajax_identifier;',
'',
'begin',
'    -- this div is isolated from region_html to support lazy loading',
'    l_html := ''<div id="'' || l_esc_static_id ||''-plugin'' || ''" class ="insumRegionClass">'';',
'',
'    l_html := l_html || region_html(',
'                 p_plugin => p_plugin,',
'                 p_region => p_region',
'                 );',
'    l_html := l_html || ''</div>'';          ',
'',
'    output_clob(l_html);',
'',
'end ajax_callback;'))
,p_api_version=>3
,p_render_function=>'render'
,p_ajax_function=>'ajax_callback'
,p_standard_attributes=>'SOURCE_LOCATION:AJAX_ITEMS_TO_SUBMIT'
,p_substitute_attributes=>true
,p_version_scn=>442395760
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>19
);
wwv_flow_imp_shared.create_plugin_attr_group(
 p_id=>wwv_flow_imp.id(198828824302091700)
,p_plugin_id=>wwv_flow_imp.id(198826809471168579)
,p_title=>'Advanced'
,p_display_sequence=>100
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(198829304132070123)
,p_plugin_id=>wwv_flow_imp.id(198826809471168579)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'lazy_load_yn'
,p_prompt=>'Lazy Load'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_is_translatable=>false
,p_attribute_group_id=>wwv_flow_imp.id(198828824302091700)
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h3>Lazy Loading</h3><p></p><p>Specify whether to load the region independently of the data for the region.</p>',
'        <p>When lazy loading is specified, the page is rendered immediately, showing an empty region, until the data is loaded.',
'        Generally, the page is not displayed until all of the page is loaded and ready to be rendered.',
'        Therefore, if it takes 5 seconds to load all of the data for a region, without lazy loading, the end user would have to wait 5 seconds before the page started to render.</p>',
'        <p>Note - Lazy Loading should only be utilized on data sets that take significant time to load, as this adds unnecessary processing overhead on the database for regions that load quickly.</p>'))
);
wwv_flow_imp_shared.create_plugin_std_attribute(
 p_id=>wwv_flow_imp.id(55035629161244680)
,p_plugin_id=>wwv_flow_imp.id(198826809471168579)
,p_name=>'SOURCE_LOCATION'
,p_is_required=>false
,p_depending_on_has_to_exist=>true
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '0A66756E6374696F6E20696E73756D496E69744D79526567696F6E282070526567696F6E49642C2070416A617849442C20704974656D73546F5375626D697429207B0A0A20202020617065782E64656275672E6C6F672827696E73756D496E69744D7952';
wwv_flow_imp.g_varchar2_table(2) := '6567696F6E2070526567696F6E49643A2027202B2070526567696F6E4964293B0A0A20202020617065782E726567696F6E2E637265617465282070526567696F6E49642C207B0A2020202020202020747970653A2022696E73756D426F696C6572706C61';
wwv_flow_imp.g_varchar2_table(3) := '7465526567696F6E222C20202F2F206368616E6765207468697320746F20726570726573656E7420796F757220726567696F6E20747970650A2020202020202020666F6375733A2066756E6374696F6E2829207B0A2020202020202020202020202F2F20';
wwv_flow_imp.g_varchar2_table(4) := '61646420636F646520746F20666F63757320726567696F6E0A2020202020202020202020206E756C6C3B0A20202020202020207D2C0A2020202020202020726566726573683A2066756E6374696F6E2829207B0A20202020202020202020202076617220';
wwv_flow_imp.g_varchar2_table(5) := '6C5370696E6E657224203D20617065782E7574696C2E73686F775370696E6E65722820242820222322202B2070526567696F6E4964202B20222D706C7567696E222920293B0A202020202020202020202020617065782E7365727665722E706C7567696E';
wwv_flow_imp.g_varchar2_table(6) := '280A202020202020202020202020202020202020202070416A617849442C0A20202020202020202020202020202020202020207B200A202020202020202020202020202020202020202020202020706167654974656D733A20704974656D73546F537562';
wwv_flow_imp.g_varchar2_table(7) := '6D69740A20202020202020202020202020202020202020207D2C200A20202020202020202020202020202020202020207B200A202020202020202020202020202020202020202020202020726566726573684F626A6563743A202428272327202B207052';
wwv_flow_imp.g_varchar2_table(8) := '6567696F6E4964292C20202F2F207472696767657220617065786265666F72652F6166746572726566726573680A20202020202020202020202020202020202020202020202064617461547970653A202268746D6C222C20202F2F2064656661756C7420';
wwv_flow_imp.g_varchar2_table(9) := '697320226A736F6E220A202020202020202020202020202020202020202020202020737563636573733A2066756E6374696F6E2868746D6C526573706F6E736529207B200A20202020202020202020202020202020202020202020202020202020242827';
wwv_flow_imp.g_varchar2_table(10) := '23272B70526567696F6E49642B272D706C7567696E27292E7265706C616365576974682868746D6C526573706F6E7365293B202020200A202020202020202020202020202020202020202020202020202020206C5370696E6E6572242E72656D6F766528';
wwv_flow_imp.g_varchar2_table(11) := '293B0A2020202020202020202020202020202020202020202020207D0A20202020202020202020202020202020202020207D200A20202020202020202020202020202020293B202020202020202020202020200A20202020202020207D2C0A2020202020';
wwv_flow_imp.g_varchar2_table(12) := '20202066696C7465723A2066756E6374696F6E2829207B0A2020202020202020202020202F2F2061646420636F646520746F2066696C74657220746865206C6973740A2020202020202020202020206E756C6C3B0A20202020202020207D0A202020207D';
wwv_flow_imp.g_varchar2_table(13) := '20293B0A7D0A';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(55013449468244741)
,p_plugin_id=>wwv_flow_imp.id(198826809471168579)
,p_file_name=>'js/insumRegionBP.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E696E73756D526567696F6E436C617373207B0A202020206261636B67726F756E642D636F6C6F723A20766172282D2D752D636F6C6F722D3335293B0A7D';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(55020345722387193)
,p_plugin_id=>wwv_flow_imp.id(198826809471168579)
,p_file_name=>'css/insumRegionCss.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2E696E73756D526567696F6E436C6173737B6261636B67726F756E642D636F6C6F723A766172282D2D752D636F6C6F722D3335297D';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(55024301840405146)
,p_plugin_id=>wwv_flow_imp.id(198826809471168579)
,p_file_name=>'css/insumRegionCss.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '66756E6374696F6E20696E73756D496E69744D79526567696F6E28652C6E2C69297B617065782E64656275672E6C6F672822696E73756D496E69744D79526567696F6E2070526567696F6E49643A20222B65292C617065782E726567696F6E2E63726561';
wwv_flow_imp.g_varchar2_table(2) := '746528652C7B747970653A22696E73756D426F696C6572706C617465526567696F6E222C666F6375733A66756E6374696F6E28297B7D2C726566726573683A66756E6374696F6E28297B76617220743D617065782E7574696C2E73686F775370696E6E65';
wwv_flow_imp.g_varchar2_table(3) := '722824282223222B652B222D706C7567696E2229293B617065782E7365727665722E706C7567696E286E2C7B706167654974656D733A697D2C7B726566726573684F626A6563743A24282223222B65292C64617461547970653A2268746D6C222C737563';
wwv_flow_imp.g_varchar2_table(4) := '636573733A66756E6374696F6E286E297B24282223222B652B222D706C7567696E22292E7265706C61636557697468286E292C742E72656D6F766528297D7D297D2C66696C7465723A66756E6374696F6E28297B7D7D297D';
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(55864060994593591)
,p_plugin_id=>wwv_flow_imp.id(198826809471168579)
,p_file_name=>'js/insumRegionBP.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
