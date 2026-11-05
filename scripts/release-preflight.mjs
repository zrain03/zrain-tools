import {readFile,readdir} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {resolve,join} from 'node:path';
import {catalog,groups} from '../src/catalog.mjs';
const root=resolve(import.meta.dirname,'..');
const expected={
 'zrain-ui.js':'99aaa486a3ec58125bb7c69c0ad2d340ed8b82ad',
 'brand.css':'9e4c2274bd0a5b10e7aa65314a2fbe964f5223a5',
 'zrain-logo.webp':'e534a195a42465951eaccfd5861b542b1e08277f'
};
for(const [filename,sha] of Object.entries(expected)){
 const buffer=await readFile(join(root,'src',filename));
 const hash=createHash('sha1').update(`blob ${buffer.length}\0`).update(buffer).digest('hex');
 if(hash!==sha)throw Error(`Outdated or unapproved Zrain UI ${filename}: ${hash}; expected ${sha}. Run Deploy-Zrain-47-Tools.ps1 to sync official UI before publishing.`);
}
const manifest=JSON.parse(await readFile(join(root,'dist/products.json'),'utf8'));
if(catalog.length!==46||groups.length!==5||manifest.reduce((n,x)=>n+x.toolCount,0)!==46)throw Error('Incorrect catalog counts');
for(let i=0;i<manifest.length;i++){
 const group=manifest[i];
 const list=group.tools.map(slug=>catalog.find(item=>item[0]===slug)?.[1]);
 if(list.some(x=>!x))throw Error('Missing listed slug '+group.slug);
 if(list.join('|')!==[...list].sort((a,b)=>a.localeCompare(b,'en',{sensitivity:'base'})).join('|'))throw Error('A-Z order fail '+group.slug);
 for(const slug of group.tools){
  const html=await readFile(join(root,'dist',group.slug,slug,'index.html'),'utf8');
  if(!html.includes(`data-product="${slug}"`)||!html.includes('https://zrain-community.web.app/embed.js'))throw Error('Community integration wrong for '+slug);
 }
 const assets=await readdir(join(root,'dist',group.slug));
 if(assets.includes('feedback-embed.js'))throw Error('Legacy GitHub issue widget leaked into '+group.slug);
}
console.log('Preflight passed: latest approved Zrain UI SHA, 46 A-Z tools, individual Community embed.');
