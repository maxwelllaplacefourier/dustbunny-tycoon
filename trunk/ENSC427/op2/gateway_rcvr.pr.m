MIL_3_Tfile_Hdr_ 140A 140A opnet 9 4BC209A8 4BCA3312 2F payette danh 0 0 none none 0 0 none B92105BA 2338 0 0 0 0 0 0 18a9 3                                                                                                                                                                                                                                                                                                                                                                                                    ��g�      @   D   H      :  c  g  k  !  !,  !0  !4  .           	   begsim intrpt         
   ����   
   doc file            	nd_module      endsim intrpt             ����      failure intrpts            disabled      intrpt interval         ԲI�%��}����      priority              ����      recovery intrpts            disabled      subqueue                     count    ���   
   ����   
      list   	���   
          
      super priority             ����                     #define MAX_SRC_IDS		10   #define IC_SOURCPROP_RX 99       int has_inited = 0;        int pkt_received[MAX_SRC_IDS*3];   $//int hack_pkt_srcid[MAX_SRC_IDS*3];   %int hack_pkt_keyupnum[MAX_SRC_IDS*3];       $//Packet *p1_last_pkts[MAX_SRC_IDS];   $//Packet *p2_last_pkts[MAX_SRC_IDS];   $//Packet *p3_last_pkts[MAX_SRC_IDS];       Stathandle stat_neworreplace;   Stathandle stat_delay;       //Statistic lists   //List *p1_updates_stat_lst;   //List *p2_updates_stat_lst;   //List *p3_updates_stat_lst;       '//List *update_counter_change_stat_lst;   //List *delay_stat_lst;       List *create_stat_lst(char *);      %List *create_stat_lst(char *statName)   {   	List *lst;   	int stat_size;   	int i;   	   &	FIN(create_stat_lst(char *statName));   	   >	op_stat_dim_size_get (statName, OPC_STAT_GLOBAL, &stat_size);   	if(stat_size != MAX_SRC_IDS)   	{   5		op_sim_end("Bad stat dimension", statName, "", "");   	}   	   	lst = op_prg_list_create();   !	for(i = 0; i < MAX_SRC_IDS; i++)   	{   		Stathandle *sth_temp;   C		sth_temp = (Stathandle *) op_prg_mem_alloc (sizeof (Stathandle));   9		*sth_temp = op_stat_reg (statName, i, OPC_STAT_GLOBAL);   		   6		op_prg_list_insert(lst, sth_temp, OPC_LISTPOS_TAIL);   	}   	   	FRET(lst);   }                                         Z   Z          J   init   J       J   "   int stat_size_temp;   int i;       if(has_inited == 0)   {   -	printf("INITIALIZING gateway statistics\n");   	has_inited = 1;   	   @	//p1_updates_stat_lst = create_stat_lst("P1 Updates Received");   @	//p2_updates_stat_lst = create_stat_lst("P2 Updates Received");   @	//p3_updates_stat_lst = create_stat_lst("P3 Updates Received");   	   '	//p1_last_pkts = op_prg_list_create();   '	//p2_last_pkts = op_prg_list_create();   '	//p3_last_pkts = op_prg_list_create();   	   !	for(i = 0; i < MAX_SRC_IDS; i++)   	{   		//p1_last_pkts[i] = OPC_NIL;   		//p2_last_pkts[i] = OPC_NIL;   		//p3_last_pkts[i] = OPC_NIL;   @		//op_prg_list_insert(p1_last_pkts, OPC_NIL, OPC_LISTPOS_TAIL);   @		//op_prg_list_insert(p2_last_pkts, OPC_NIL, OPC_LISTPOS_TAIL);   @		//op_prg_list_insert(p3_last_pkts, OPC_NIL, OPC_LISTPOS_TAIL);   	}   	   #	for(i = 0; i < MAX_SRC_IDS*3; i++)   	{   		pkt_received[i] = 0;   	}   	   f	stat_neworreplace = op_stat_reg("Update Pkt - New or Replace" ,OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   I	stat_delay = op_stat_reg("Delay" ,OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   }   J                     J   ����   J          pr_state           Z          J   record   J                     J   �   Packet *pPkt;   //Packet *pPktOld;       int key;   int sourceid;   int key_updnm;   double generated_timestamp;       int array_index;       Objid source_prop_id;       char message_str [255];       //Packet **lastPktLst;   //Stathandle *received_stat;       #pPkt = op_pk_get(op_intrpt_strm());   if(pPkt == OPC_NIL)   {   *	op_sim_end("Nil stream pkt", "", "", "");   }       #//printf("Start getting fields\n");   ,op_pk_nfd_get(pPkt, "source_id", &sourceid);   !op_pk_nfd_get(pPkt, "key", &key);   5op_pk_nfd_get(pPkt, "key_update_number", &key_updnm);   :op_pk_nfd_get(pPkt, "source_prop_objid", &source_prop_id);   Aop_pk_nfd_get(pPkt, "generated_timestamp", &generated_timestamp);   #//printf("\tEnd getting fields\n");       //Check the fields   +if(sourceid < 0 || sourceid >= MAX_SRC_IDS)   {   )	op_sim_end("Bad source id", "", "", "");   }   else if(key_updnm < 0)   {   )	op_sim_end("Bad key_updnm", "", "", "");   }       //Basic record   if(key == 1)   {   T	//received_stat = (Stathandle *)op_prg_list_access (p1_updates_stat_lst, sourceid);   	//lastPktLst = p1_last_pkts;   }   else if (key == 2)   {   T	//received_stat = (Stathandle *)op_prg_list_access (p2_updates_stat_lst, sourceid);   	//lastPktLst = p2_last_pkts;   }   else if (key == 3)   {   T	//received_stat = (Stathandle *)op_prg_list_access (p3_updates_stat_lst, sourceid);   	//lastPktLst = p3_last_pkts;   }   else   {   #	op_sim_end("Bad key", "", "", "");   }       #array_index = sourceid*3 + (key-1);       ?//pPktOld = (Packet *)op_prg_list_access(lastPktLst, sourceid);   +//pPktOld = (Packet *)lastPktLst[sourceid];   if(pkt_received[array_index])   {   	int oldkey_updnm;   	   @	//sprintf (message_str, "[GATEWAY] %d : %d\n", sourceid, key);    	//printf (message_str);   	   	//if(pPktOld == OPC_NIL)   	//{   $	//	op_sim_end("WTF!!", "", "", "");   	//}   	   /	oldkey_updnm = hack_pkt_keyupnum[array_index];   	   	//printf("[GATEWAY] Update");   (	//printf("Old Start getting fields\n");   >	//op_pk_nfd_get(pPktOld, "key_update_number", &oldkey_updnm);   (	//printf("\tOld End getting fields\n");   	   	if(oldkey_updnm < key_updnm)   	{   $		//Trigger stat interrupt on source   .		Ici *iciptr = op_ici_create ("prop_action");   2		op_ici_attr_set (iciptr, "source_id", sourceid);   ;		op_ici_attr_set (iciptr, "key_update_number", key_updnm);   :		op_ici_attr_set (iciptr, "action", 1); //Gateway rx code   		op_ici_install(iciptr);   N		op_intrpt_schedule_remote (op_sim_time (), IC_SOURCPROP_RX, source_prop_id);       -		//printf("[GATEWAY]	 stat_neworreplace\n");   (		op_stat_write(stat_neworreplace, 1.0);   D		op_stat_write(stat_delay, (op_sim_time () - generated_timestamp));   3		//printf("[GATEWAY]	 	stat_neworreplace done\n");   		   		//if(pPkt == pPktOld)   		//{   -		//	op_sim_end("Pkts the same", "", "", "");   		//}   		   -		hack_pkt_keyupnum[array_index] = key_updnm;    		//lastPktLst[sourceid] = pPkt;   -//		op_prg_list_remove(lastPktLst, sourceid);   4//		op_prg_list_insert(lastPktLst, pPkt, sourceid);    	   		//op_pk_destroy(pPktOld);   	   	}   	else   	{   		//if(pPkt == pPktOld)   		//{   -		//	op_sim_end("Pkts the same", "", "", "");   		//}   		//op_pk_destroy(pPkt);   	}   }   else   {   	   	Ici *iciptr;   	pkt_received[array_index] = 1;   	   #	//Trigger stat interrupt on source   '	iciptr= op_ici_create ("prop_action");   1	op_ici_attr_set (iciptr, "source_id", sourceid);   :	op_ici_attr_set (iciptr, "key_update_number", key_updnm);   9	op_ici_attr_set (iciptr, "action", 1); //Gateway rx code   	op_ici_install(iciptr);   M	op_intrpt_schedule_remote (op_sim_time (), IC_SOURCPROP_RX, source_prop_id);       	//printf("[GATEWAY] New");   	   '	op_stat_write(stat_neworreplace, 1.0);   C	op_stat_write(stat_delay, (op_sim_time () - generated_timestamp));       &	//if(lastPktLst[sourceid] != OPC_NIL)   	//{   &	//	op_sim_end("AHAHAHA", "", "", "");   	//}   	   ,	hack_pkt_keyupnum[array_index] = key_updnm;   	   	//lastPktLst[sourceid] = pPkt;   	   ,//	op_prg_list_remove(lastPktLst, sourceid);   3//	op_prg_list_insert(lastPktLst, pPkt, sourceid);    }       op_pk_destroy(pPkt);       /*   =sprintf (message_str, "[GATEWAY] %d : %d\n", sourceid, key);    printf (message_str);       %printf("[GATEWAY]	 received_stat\n");   #op_stat_write(*received_stat, 1.0);   ,printf("[GATEWAY]	 	received_stat done\n ");   */   J           ����             pr_state                        �   Z      i   Y      Z          J   tr_0   J       ����          ����          J    ����   J          ����                       pr_transition               �   =        R   �   '  0   '     L          J   tr_1   J       ����          ����          J    ����   J          ����                       pr_transition                       P1 Updates Received   
    ����   normal   discrete        ԲI�%��}   P2 Updates Received   
    ����   normal   discrete        ԲI�%��}   P3 Updates Received   
    ����   normal   discrete        ԲI�%��}   Update Counter Change   
    ������������        ԲI�%��}   Delay        ������������        ԲI�%��}   Update Pkt - New or Replace        ����   bucket/1 secs/sum_time   linear        ԲI�%��}              	keyupdate            