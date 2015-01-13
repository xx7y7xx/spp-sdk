Tree=function(){ 
	this.list=new Array();
	this.MeshObjs=new Array();
	this.Materials=new Array();
	this.Textures=new  Array();
	this.flagstex=new  Array();
}

Tree.prototype={
	count:0,
	xmlRoot:null,
	fread:null,
	TexSource:null,
	TexTarget:null,
	initByMesh: function(fread,texSource,texTarget){//��Ա��ʼ��
					this.fread=fread;
					this.TexSource=texSource;
					this.TexTarget=texTarget;
					var effect= new xmlDocument();
					if(!this.fread){
						alret("effect.js is  failed to initialize")
					}
					effect.Parse(this.fread);
 					this.xmlRoot=effect.root;
					rootnode = this.xmlRoot;
					lib=rootnode.GetChild("lib");
					meshobjs=lib.GetChildren();

					this.Textures=this.getTextureAllByMeshobjs(meshobjs);

					meshobjs=lib.GetChildren();
					var i=0;
					while(meshobjs.HasNext()){
					var meshobj=meshobjs.Next();
						this.MeshObjs[i]=meshobj.GetAttributeValue("name");
						//alert(this.MeshObjs[i]);
						i++;
					} 
					
	},
	initByMat: function(fread,texSource,texTarget){//��Ա��ʼ��
					this.fread=fread;
					this.TexSource=texSource;
					this.TexTarget=texTarget;
					var effect = new xmlDocument();
					if(!this.fread){
						alret("effect.js is  failed to initialize")
					}
					effect.Parse(this.fread);
 					this.xmlRoot=effect.root;
					rootnode = this.xmlRoot;
					lib=rootnode.GetChild("lib");
					materials=lib.GetChildren();
					this.Textures=this.getTextureAllByMaterials(materials);
					var i=0;
					materials=lib.GetChildren();
					
					while(materials.HasNext()){
					var material=materials.Next();
						this.Materials[i]=material.GetAttributeValue("name");
						//alert(this.list[i]);
						i++;
					} 
					
	},
	getMaterialByMesh:function(meshobj){//����iDocumentNode	����	meshobj��string
		var imeshobj=this.getMeshobj(meshobj);
		if(!imeshobj){
			return null;
		};
		var imaterial=imeshobj;
		return imaterial;
	},
	deleteAllMaterialOfOutSide:function(meshobj,materials,matname){//����bool	meshobj:String materials :iDocumentNode;matname:String
		if(!this.isMeshobj(meshobj)){
			//alert("Does not exist node");
			return false;
		};
		
		imaterials=materials.GetChildren();
		while(imaterials.HasNext()){
			var imaterial=imaterials.Next();
				if(imaterial.GetAttributeValue("name")==matname){						
						if (imaterial.RemoveChildren(imaterial.GetChildren())){
							return true;
						}
						
					break;
				};
		} ;		
		return false;
	},
	deleteAllMaterialOfOutSideByMat:function(materials,sd3matname,matname){//����bool	meshobj:String materials :iDocumentNode;matname:String
		if(!this.isMaterialByMat(sd3matname)){
			//alert("Does not exist node");
			return false;
		};
		imaterials=materials.GetChildren();
		while(imaterials.HasNext()){
			var imaterial=imaterials.Next();
				if(imaterial.GetAttributeValue("name")==matname){						
						if (imaterial.RemoveChildren(imaterial.GetChildren())){
							return true;
						}
						
					break;
				};
		} ;		
		return false;
	},
	deleteAllMaterial:function(meshobj){//����bool��	����	meshobj��string
		var imeshobj=getMeshobj(meshobj);
		if(imeshobj==null){
			return false;
		}
		if (imeshobj.RemoveChildren(imeshobj.GetChildren())){
			return true;
		}
		return false;
	},
	getMeshobj:function(meshobj){//����iDocumentNode	����	meshobj��string
			if(!this.isMeshobj(meshobj)){
				//alert("Does not exist node "+meshobj);
				return null;
			};
			rootnode = this.xmlRoot;
			lib=rootnode.GetChild("lib");
			meshobjs=lib.GetChildren();
			while(meshobjs.HasNext()){
			var imeshobj=meshobjs.Next();
				if(imeshobj.GetAttributeValue("name")==meshobj){
					return imeshobj;
				};
			} ;
	},
	isMeshobj:function(meshobj){//����bool	����	meshobj��string
				for (var j=0; j<=this.MeshObjs.length;j++){

					if( meshobj == this.MeshObjs[j] ){
						return true;
					};
				}
				return false;
	},
	addShaderOfOutSide:function(){//����bool	�޸�shader.xml  Ԥ��
		
	},
	modifyTexsOfOutSide:function(){//����bool	�޸�texture���� Ԥ��
	},
	modifyMaterialOfOutSidebyMesh:function(materials,meshobj,matname){//����bool ���� materials:iDocumentNode; meshobj��string ��matname��string
		//������������ֱ�ӷ��أ�		
		if(!this.isMeshobj(meshobj))
			return true;
		
		var imeshobj=this.getMeshobj(meshobj);
		


		var smaterial=this.getMaterialByMeshobj(imeshobj);

		if(!smaterial) 
			return false;
		
		
		this.deleteAllMaterialOfOutSide(meshobj,materials,matname);
		
		//���Ŀ��imaterial��effect�ṩ�Ĳ�Դmaterial
		
		var dmaterials=materials.GetChildren();
		
		while(dmaterials.HasNext()){
			var dmaterial=dmaterials.Next();
				if(dmaterial.GetAttributeValue("name")==matname){
				            //����Ŀ���ǩ��
						var dname=dmaterial.value;
						var dmtname=dmaterial.GetAttributeValue("name");
						if(!this.copyNode(dmaterial, smaterial)){
							//alert("���ʧ��"+smaterial.GetAttributeValue("name"));
							return false;
						}else{
						    //�ָ�Ŀ��ڵ��ǩ��
							dmaterial.value=dname;
							dmaterial.SetAttribute("name",dmtname);
							return true;
						}
				}
		} ;
		return false;
	},
	modifyMaterialOfOutSideByMeshMat:function(meshobj,materials,sd3matname,matname){
		if(!this.isMeshobj(meshobj))
			return false;
		var imeshobj=this.getMeshobj(meshobj);
		var smaterial=this.getMaterialByMeshobjMat(imeshobj,sd3matname);
		if(!smaterial) 
			return false;
		this.deleteAllMaterialOfOutSide(meshobj,materials,matname);
		
		var dmaterials=materials.GetChildren();
		while(dmaterials.HasNext()){
			var dmaterial=dmaterials.Next();
				if(dmaterial.GetAttributeValue("name")==matname){
						var dname=dmaterial.value;
						var dmtname=dmaterial.GetAttributeValue("name");
						if(!this.copyNode(dmaterial, smaterial)){
							//alert("���ʧ��"+smaterial.GetAttributeValue("name"));
							return false;
						}else{

							dmaterial.value=dname;
							dmaterial.SetAttribute("name",dmtname);
							return true;
						}
				}
		} ;
		return false;		
	
	
	
	},
	modifyMaterialOfOutSide3Mat:function(materials,sd3matname,matname){
		if(!this.isMaterialByMat(sd3matname))
			return false;
		var smaterial=this.getMaterialByMat(sd3matname);
		if(!smaterial) 
			return false;
		this.deleteAllMaterialOfOutSideByMat(materials,sd3matname,matname)
		var dmaterials=materials.GetChildren();
		while(dmaterials.HasNext()){
			var dmaterial=dmaterials.Next();
				if(dmaterial.GetAttributeValue("name")==matname){
						var dname=dmaterial.value;
						var dmtname=dmaterial.GetAttributeValue("name");
						//alert(dname+" "+dmtname)
						if(!this.copyNode(dmaterial, smaterial)){
							//alert("���ʧ��"+smaterial.GetAttributeValue("name"));
							return false;
						}else{
							dmaterial.value=dname;
							dmaterial.SetAttribute("name",dmtname);
							//alert(dname+" "+dmtname)
							return true;
						}
				}
		} ;
		return false;		
	
	
	
	},
	copyNode:function (dnode, snode){//����bool	����	dnode��iDocumentNode ��snode��iDocumentNode
				dnode.value = snode.value;
				var sai = snode.GetAttribute();  //��ȡsnode���������Եĵ�����
				while(sai.HasNext())      //ɨ����������
				{
				var att = sai.Next();    //��ȡ����
				dnode.SetAttribute(att.name,att.value);   //Ϊdnode������ͬ��������
				}
			    
				var sci = snode.GetChildren();   //��ȡsnode�������ӽڵ�ĵ�����
				while(sci.HasNext())     //ɨ�����е��ӽڵ�
				{
					var tchild = sci.Next();
					if(!this.copyNode(dnode.CreateChild(tchild.type),tchild))  //���ִ���Ƿ�ɹ�
					{
					System.exitcode = 32;
					}
				}
			return true;
	},
	isMaterial:function(meshobj,sd3matname){//����bool ����	meshobj:iDocumentNode;sd3matname:string
			var imeshobj=this.getMeshobj(meshobj)
			var imaterias=imeshobj.GetChildren();
			while(imaterials.HasNext()){
				var imaterial=imaterials.Next();
				if(imaterial.GetAttributeValue("name")==sd3matname){
							//alert("Does not exist material ");
							return true;
						}						
					
			};	
			return false;
	},
	isMaterialByMat:function(sd3matname){//����bool  ����	meshobj:iDocumentNode;sd3matname:string
				for (var j=0; j<=this.Materials.length;j++){
					if( sd3matname == this.Materials[j] ){
						return true;
					};
				}
				return false;
	},
	getMaterialByMeshobjMat:function(meshobj,sd3matname){//����iDocumentNode	����	meshobj:iDocumentNode;sd3matname:string
			var imaterials=meshobj.GetChildren();
			while(imaterials.HasNext()){
				var imaterial=imaterials.Next();
				if(imaterial.GetAttributeValue("name")==sd3matname){
							return imaterial;
				};						
					
			};	
			return null;
	},
	getMaterialByMeshobj:function(meshobj){//����iDocumentNode	����	meshobj:iDocumentNode;
			var imaterials=meshobj.GetChildren();
			if(imaterials.HasNext()){
				var imaterial=imaterials.Next();
				return imaterial;				
			}		
			return null;
	},
	getMaterialByMat:function(sd3matname){//����iDocumentNode   ����	sd3matname:string
			if(!this.isMaterialByMat(sd3matname)){
				return null;
			}
			rootnode = this.xmlRoot;
			lib=rootnode.GetChild("lib")
			var imaterials=lib.GetChildren();
			while(imaterials.HasNext()){
				var imaterial=imaterials.Next();
				if(imaterial.GetAttributeValue("name")==sd3matname){
							return imaterial;
				};						
					
			};	
			return null;
	},
	getTextureAllByMaterials:function(materials){//����Array������ materials iDocumentNode 
		itextures=new Array();
		var i=0;
		while(materials.HasNext()){
			var material=materials.Next();
			var matchilds = material.GetChildren();
			while(matchilds.HasNext()){
				var	matchild=matchilds.Next();
					if(matchild.GetAttributeValue("type")=="texture"){
 						if(i==0){
							itextures[0]=matchild.contentsValue;
							i++;
						} else{
							var iii=0;
							for(ii=0;ii<i;ii++){
								if(itextures[ii]==matchild.contentsValue){
									iii++;
								}
							} 
							if(iii==0){		
									itextures[i]=matchild.contentsValue;
									i++;
							}
						}		
				}
				
			}
		}
		return itextures;  
	} ,
	getTextureAllByMeshobjs:function(meshobjs){//����Array������ meshobjs: iDocumentNode 
			itextures=new Array();
			var i=0;
			while(meshobjs.HasNext()){
				var meshobj=meshobjs.Next();
				var materials = meshobj.GetChildren();
				while(materials.HasNext()){
					var material=materials.Next();
					var matchilds = material.GetChildren();
					while(matchilds.HasNext()){
						var	matchild=matchilds.Next();
							if(matchild.GetAttributeValue("type")=="texture"){
								if(i==0){
									itextures[0]=matchild.contentsValue;
									this.flagstex[0]=false;
									i++;
								} else{
									var iii=0;
									for(ii=0;ii<i;ii++){
										if(itextures[ii]==matchild.contentsValue){
											iii++;
										}
									} 
									if(iii==0){		
											itextures[i]=matchild.contentsValue;
											i++;
									}
								}		
						}
						
					}
				}
			}
		return itextures;  
	} ,
	copyTextureAll:function(){
 		for(i=0;i<this.Textures.length;i++){
			itexs=this.TexSource+this.Textures[i];
			itexd=this.TexTarget+this.Textures[i];
			  if(!VFS.Exists(itexs)){
				//alert("Please check the textures file exists!")
				return false;
			}
			
			if(VFS.Exists(itexd)){
				continue;
			}
			if(!VFS.Copy(itexs,itexd)){
					 return false;
			}
		}
		return true; 
	} ,
	addTextureNodeAll:function(textures){
		if(!this.isTexture(textures))
		{
			for(i=0;i<this.Textures.length;i++){
				itexture= textures.CreateChild(xmlDocument.NODE_ELEMENT);
				itexture.value="texture";
				itexture.SetAttribute("name",this.Textures[i]);
				file=itexture.CreateChild(xmlDocument.NODE_ELEMENT);
				file.value="file";
				pathfile = file.CreateChild(xmlDocument.NODE_TEXT);   //file�е�·����Ϣ���Կ����������ӽڵ㣬ͨ��contentsValue���Ի�ȡ��
				pathfile.value = "/art/textures/effectextures/"+this.Textures[i];
			}
		}
	},
	isTexture:function(textures){
		itextures=textures.GetChildren();
		var i=0;
		while(itextures.HasNext()){
		var itexture=itextures.Next();
			itexturename=itexture.GetAttributeValue("name");
			for(i=0;i<this.Textures.length;i++){
				if(this.Textures[i]==itexturename){
					//alert("texture node is exists");
					return true;
				}
			}
		} 
		return false;
	}
}