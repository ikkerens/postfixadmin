{if isset($search._)}
    {assign var="search" value=$search._}
{else}
    {assign var="search" value=''}
{/if}

	<thead>
	{#tr_header#}
		{if $CONF.show_status===YES}<th></th>{/if}
		<th>{$PALANG.pOverview_mailbox_username}</th>
		{if $display_mailbox_aliases==true}
			<th>{$PALANG.to}</th>
		{/if}
		<th>{$PALANG.name}</th>
		{if $CONF.quota===YES}<th>{$PALANG.pOverview_mailbox_quota}</th>{/if}
		<th>{$PALANG.last_modified}</th>
		<th>{$PALANG.active}</th>
		{assign var="colspan" value="`$colspan-6`"}
		<th colspan="{$colspan}">&nbsp;</th>
	</tr>
	</thead>
	<tbody>
	{foreach from=$tMailbox item=item key=i}
		<tr>
			{if $CONF.show_status===YES}
				<td>{$gen_show_status_mailbox[$i]}</td>
			{/if}
			<td>
				{if $search eq ""}
					{$item.username}
				{else}
					{$item.username|replace:$search:"<span class='searchresult'>$search</span>"}
				{/if}
			</td>
			{if $display_mailbox_aliases==true}
				<td>
				{if $item.goto_mailbox == 1}
					Mailbox<br/>
				{else}
					Forward only<br/>
				{/if}
				{foreach from=$item.goto_other item=item2 key=j}
					{if $search eq ""}
						{$item2}
					{else}
						{$item2|replace:$search:"<span class='searchresult'>$search</span>"}
					{/if}
					<br/>
				{/foreach}
				</td>
			{/if}
			<td>{$item.name}</td>
			{if $CONF.quota===YES}
				<td>
				{if $item.quota==0}
					{$PALANG.pOverview_unlimited}
				{elseif $item.quota<0}
					{$PALANG.pOverview_disabled}
				{else}
					{if $boolconf_used_quotas}


						{if $divide_quota.percent[$i] > $CONF.quota_level_high_pct}
							{assign var="quota_level" value="high"}
						{elseif $divide_quota.percent[$i] > $CONF.quota_level_med_pct}
							{assign var="quota_level" value="mid"}
						{else}
							{assign var="quota_level" value="low"}
						{/if}
						<div class="quota quota_{$quota_level}" style="width:{$divide_quota.quota_width[$i]}px;"></div>
						<div class="quota_bg"></div></div>
						<div class="quota_text quota_text_{$quota_level}">{$divide_quota.current[$i]} / {$divide_quota.quota[$i]}</div>
					{else}
						{$divide_quota.quota[$i]}
					{/if}
				{/if}
				</td>
			{/if}
			<td>{$item.modified}</td>
			<td><a href="{#url_editactive#}mailbox&amp;id={$item.username|escape:"url"}&amp;active={if ($item.active==0)}1{else}0{/if}&amp;token={$smarty.session.PFA_token|escape:"url"}"
				>{if $item.active==1}{$PALANG.YES}{else}{$PALANG.NO}{/if}</a></td>
			{if $CONF.vacation_control_admin===YES && $CONF.vacation===YES}
				{if $item.v_active!==-1}
					{if $item.v_active==1}
						{assign var="v_active" value=$PALANG.pOverview_vacation_edit}
					{else}
						{assign var="v_active" value=$PALANG.pOverview_vacation_option}
					{/if}
					<td><a href="vacation.php?username={$item.username|escape:"url"}">{$v_active}</a></td>
				{/if}
			{else}
					<td>&nbsp;</td>
			{/if}
			{assign var="edit_aliases" value=0}
			{if $authentication_has_role.global_admin!==true && $CONF.alias_control_admin===YES}{assign var="edit_aliases" value=1}{/if}
			{if $authentication_has_role.global_admin==true && $CONF.alias_control===YES}{assign var="edit_aliases" value=1}{/if}
			{if $edit_aliases==1}
				<td><a href="edit.php?table=alias&amp;edit={$item.username|escape:"url"}">{$PALANG.alias}</a></td>
			{/if}
			<td><a href="edit.php?table=mailbox&amp;edit={$item.username|escape:"url"}">{$PALANG.edit}</a></td>
			<td><a href="delete.php?table=mailbox&amp;delete={$item.username|escape:"url"}&amp;token={$smarty.session.PFA_token|escape:"url"}"
				onclick="return confirm ('{$PALANG.confirm}{$PALANG.mailboxes}: {$item.username}');">{$PALANG.del}</a></td>
		</tr>
	{/foreach}
	</tbody>
</table>
